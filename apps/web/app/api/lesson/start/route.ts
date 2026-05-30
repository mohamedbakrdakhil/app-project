import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";
import type { LessonContentPublic } from "@masteri/core";

const StartBodySchema = z.object({
  levelId: z.string().uuid(),
});

export async function POST(request: NextRequest) {
  try {
    const supabase = await createSupabaseServerClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    const body = StartBodySchema.parse(await request.json());
    const admin = createSupabaseAdminClient();

    // Check plan and daily usage
    const today = new Date().toISOString().split("T")[0]!;

    const [{ data: subscription }, { data: usage }] = await Promise.all([
      admin.from("plan_subscriptions").select("plan").eq("user_id", user.id).maybeSingle(),
      admin.from("daily_lesson_usage").select("lessons_started").eq("user_id", user.id).eq("usage_date", today).maybeSingle(),
    ]);

    const plan = subscription?.plan ?? "free";
    const lessonsToday = (usage?.lessons_started ?? 0);
    const FREE_DAILY_LIMIT = 3;

    if (plan === "free" && lessonsToday >= FREE_DAILY_LIMIT) {
      return NextResponse.json({
        error: "daily_limit_reached",
        message: `Limite quotidienne atteinte (${FREE_DAILY_LIMIT} leçons/jour en gratuit). Reviens demain ou passe en Premium.`,
        plan: "free",
        limit: FREE_DAILY_LIMIT,
      }, { status: 429 });
    }

    // Increment usage
    await admin.from("daily_lesson_usage").upsert({
      user_id: user.id,
      usage_date: today,
      lessons_started: lessonsToday + 1,
    }, { onConflict: "user_id,usage_date" });

    const { data: level, error: levelErr } = await admin
      .from("levels")
      .select("id, title_fr, content_public, is_published")
      .eq("id", body.levelId)
      .eq("is_published", true)
      .single();

    if (levelErr || !level) {
      return NextResponse.json({ error: "Level not found" }, { status: 404 });
    }

    const { data: attempt, error: attemptErr } = await admin
      .from("lesson_attempts")
      .insert({ user_id: user.id, level_id: level.id, status: "started" })
      .select("id")
      .single();

    if (attemptErr || !attempt) {
      return NextResponse.json({ error: "Failed to create attempt" }, { status: 500 });
    }

    return NextResponse.json({
      attemptId: attempt.id,
      level: {
        id: level.id,
        titleFr: level.title_fr,
        contentPublic: level.content_public as LessonContentPublic,
      },
    });
  } catch (e) {
    if (e instanceof z.ZodError) return NextResponse.json({ error: "Invalid input" }, { status: 400 });
    return NextResponse.json({ error: "Internal error" }, { status: 500 });
  }
}
