import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";
import { calculateLessonScore } from "@masteri/core";

const CompleteBodySchema = z.object({
  attemptId: z.string().uuid(),
});

export async function POST(request: NextRequest) {
  try {
    const supabase = await createSupabaseServerClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    const body = CompleteBodySchema.parse(await request.json());
    const admin = createSupabaseAdminClient();

    const { data: attempt } = await admin
      .from("lesson_attempts")
      .select("id, user_id, level_id, status, started_at")
      .eq("id", body.attemptId)
      .eq("user_id", user.id)
      .single();

    if (!attempt || attempt.status !== "started") {
      return NextResponse.json({ error: "Attempt not found or already completed" }, { status: 404 });
    }

    const { data: questionAttempts } = await admin
      .from("question_attempts")
      .select("is_correct, xp_earned")
      .eq("lesson_attempt_id", body.attemptId);

    const qas = questionAttempts ?? [];
    const correctCount = qas.filter((q) => q.is_correct).length;
    const totalRecallCount = qas.length;
    const scoreResult = calculateLessonScore({ correctCount, totalRecallCount });

    const durationSeconds = Math.round((Date.now() - new Date(attempt.started_at as string).getTime()) / 1000);

    await admin.from("lesson_attempts").update({
      status: "completed",
      completed_at: new Date().toISOString(),
      score_percent: scoreResult.scorePercent,
      xp_earned: scoreResult.totalXp,
      duration_seconds: durationSeconds,
    }).eq("id", body.attemptId);

    const { data: existingProgress } = await admin
      .from("user_progress")
      .select("attempts_count, total_xp_earned, best_score_percent, is_completed, first_completed_at")
      .eq("user_id", user.id)
      .eq("level_id", attempt.level_id as string)
      .maybeSingle();

    const wasCompleted = existingProgress?.is_completed ?? false;
    const newIsCompleted = scoreResult.isCompleted || wasCompleted;
    const firstCompletedAt = wasCompleted
      ? (existingProgress?.first_completed_at ?? null)
      : (scoreResult.isCompleted ? new Date().toISOString() : null);
    const bestScore = Math.max(scoreResult.scorePercent, existingProgress?.best_score_percent ?? 0);

    await admin.from("user_progress").upsert({
      user_id: user.id,
      level_id: attempt.level_id,
      is_completed: newIsCompleted,
      best_score_percent: bestScore,
      attempts_count: (existingProgress?.attempts_count ?? 0) + 1,
      total_xp_earned: (existingProgress?.total_xp_earned ?? 0) + scoreResult.totalXp,
      first_completed_at: firstCompletedAt,
      last_attempt_at: new Date().toISOString(),
    }, { onConflict: "user_id,level_id" });

    const nowUTC = new Date();
    const todayUTC = nowUTC.toISOString().split("T")[0] as string;
    const yesterdayUTC = new Date(nowUTC.getTime() - 86400000).toISOString().split("T")[0] as string;

    const { data: profile } = await admin
      .from("profiles")
      .select("total_xp, streak, last_active")
      .eq("id", user.id)
      .single();

    const { data: todayEntry } = await admin
      .from("streak_history")
      .select("activity_date")
      .eq("user_id", user.id)
      .eq("activity_date", todayUTC)
      .maybeSingle();

    const { data: yesterdayEntry } = await admin
      .from("streak_history")
      .select("activity_date")
      .eq("user_id", user.id)
      .eq("activity_date", yesterdayUTC)
      .maybeSingle();

    let newStreak = profile?.streak ?? 0;
    if (todayEntry) {
      // already counted today — streak unchanged
    } else if (yesterdayEntry) {
      newStreak += 1;
    } else {
      newStreak = 1;
    }

    await admin.from("profiles").update({
      total_xp: (profile?.total_xp ?? 0) + scoreResult.totalXp,
      streak: newStreak,
      last_active: todayUTC,
    }).eq("id", user.id);

    await admin.from("streak_history").upsert({
      user_id: user.id,
      activity_date: todayUTC,
      xp_earned: scoreResult.totalXp,
      levels_completed: scoreResult.isCompleted ? 1 : 0,
    }, { onConflict: "user_id,activity_date" });

    const { data: level } = await admin
      .from("levels")
      .select("content_public")
      .eq("id", attempt.level_id as string)
      .single();

    type LevelStep = { type: string; masteredConcepts?: string[] };
    const steps = (level?.content_public as { steps: LevelStep[] } | null)?.steps ?? [];
    const masteredConcepts: string[] = [];
    for (const step of steps) {
      if (step.type === "complete" && step.masteredConcepts) {
        masteredConcepts.push(...step.masteredConcepts);
      }
    }

    for (const conceptKey of masteredConcepts) {
      await admin.from("spaced_rep_cards").upsert({
        user_id: user.id,
        level_id: attempt.level_id,
        concept_key: conceptKey,
        concept_label: conceptKey,
        ease_factor: 2.5,
        interval_days: 1,
        repetitions: 0,
        lapses: 0,
        next_review_date: new Date(Date.now() + 86400000).toISOString().split("T")[0],
      }, { onConflict: "user_id,concept_key" });
    }

    return NextResponse.json({
      scorePercent: scoreResult.scorePercent,
      xpEarned: scoreResult.totalXp,
      isCompleted: scoreResult.isCompleted,
      isPerfect: scoreResult.isPerfect,
      masteredConcepts,
    });
  } catch (e) {
    if (e instanceof z.ZodError) return NextResponse.json({ error: "Invalid input" }, { status: 400 });
    console.error(e);
    return NextResponse.json({ error: "Internal error" }, { status: 500 });
  }
}
