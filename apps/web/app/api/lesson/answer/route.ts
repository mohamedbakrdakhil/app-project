import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";
import { XP_RULES } from "@masteri/core";

const AnswerBodySchema = z.object({
  attemptId: z.string().uuid(),
  stepIndex: z.number().int().nonnegative(),
  questionKey: z.string().min(1),
  selectedIndex: z.number().int().min(0).max(3).optional(),
  textAnswer: z.string().max(200).optional(),
}).refine(d => d.selectedIndex !== undefined || d.textAnswer !== undefined, {
  message: "Either selectedIndex or textAnswer is required",
});

export async function POST(request: NextRequest) {
  try {
    const supabase = await createSupabaseServerClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    const body = AnswerBodySchema.parse(await request.json());
    const admin = createSupabaseAdminClient();

    const { data: attempt } = await admin
      .from("lesson_attempts")
      .select("id, user_id, level_id, status")
      .eq("id", body.attemptId)
      .eq("user_id", user.id)
      .eq("status", "started")
      .single();

    if (!attempt) return NextResponse.json({ error: "Attempt not found" }, { status: 404 });

    const { data: existing } = await admin
      .from("question_attempts")
      .select("id, is_correct, xp_earned")
      .eq("lesson_attempt_id", body.attemptId)
      .eq("step_index", body.stepIndex)
      .maybeSingle();

    if (existing) {
      const { data: answerKey } = await admin
        .from("level_answer_keys")
        .select("answers")
        .eq("level_id", attempt.level_id)
        .single();
      type AnyEntry = { correctIndex?: number; acceptedAnswers?: string[]; explanation: string; conceptKey: string };
      const answers = answerKey?.answers as Record<string, AnyEntry> | undefined;
      const entry = answers?.[body.questionKey];
      return NextResponse.json({
        isCorrect: existing.is_correct,
        xpEarned: existing.xp_earned,
        correctIndex: entry?.correctIndex ?? 0,
        explanation: entry?.explanation ?? "",
      });
    }

    const { data: answerKeyRow } = await admin
      .from("level_answer_keys")
      .select("answers")
      .eq("level_id", attempt.level_id)
      .single();

    if (!answerKeyRow) return NextResponse.json({ error: "Answer key not found" }, { status: 500 });

    type AnyEntry = { correctIndex?: number; acceptedAnswers?: string[]; explanation: string; conceptKey: string };
    const answers = answerKeyRow.answers as Record<string, AnyEntry>;
    const entry = answers[body.questionKey];
    if (!entry) return NextResponse.json({ error: "Question not found" }, { status: 400 });

    let isCorrect: boolean;
    if ("acceptedAnswers" in entry && entry.acceptedAnswers) {
      // fill_blank: normalize and compare
      const normalized = (body.textAnswer ?? "").trim().toLowerCase();
      isCorrect = entry.acceptedAnswers.some(a => a.trim().toLowerCase() === normalized);
    } else {
      // MCQ
      isCorrect = body.selectedIndex === entry.correctIndex;
    }

    const xpEarned = isCorrect ? XP_RULES.correctAnswer : XP_RULES.incorrectAnswer;

    await admin.from("question_attempts").insert({
      lesson_attempt_id: body.attemptId,
      user_id: user.id,
      level_id: attempt.level_id,
      step_index: body.stepIndex,
      question_key: body.questionKey,
      answer: "acceptedAnswers" in entry && entry.acceptedAnswers
        ? { textAnswer: body.textAnswer }
        : { selectedIndex: body.selectedIndex },
      is_correct: isCorrect,
      xp_earned: xpEarned,
    });

    return NextResponse.json({
      isCorrect,
      xpEarned,
      correctIndex: entry.correctIndex ?? 0,
      explanation: entry.explanation,
    });
  } catch (e) {
    if (e instanceof z.ZodError) return NextResponse.json({ error: "Invalid input" }, { status: 400 });
    return NextResponse.json({ error: "Internal error" }, { status: 500 });
  }
}
