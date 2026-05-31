import { NextRequest, NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import type { LessonContentPublic } from "@masteri/core";

type RecallQuestion = {
  levelId: string;
  questionKey: string;
  question: string;
  options: [string, string, string, string];
  subjectId: string;
  levelTitle: string;
};

export async function GET(request: NextRequest) {
  try {
    const supabase = await createSupabaseServerClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { searchParams } = new URL(request.url);
    const subjectParam = searchParams.get("subject");
    const countParam = searchParams.get("count");
    const count = Math.min(
      20,
      Math.max(1, parseInt(countParam ?? "10", 10) || 10),
    );

    // Build query: join levels → chapters → subjects
    let query = supabase
      .from("levels")
      .select(
        `
        id,
        title_fr,
        content_public,
        chapters!inner (
          subject_id
        )
      `,
      )
      .eq("is_published", true);

    if (subjectParam) {
      query = query.eq("chapters.subject_id", subjectParam);
    }

    const { data: levels, error } = await query;

    if (error) {
      return NextResponse.json({ error: "Database error" }, { status: 500 });
    }

    // Extract recall steps from all levels
    const allQuestions: RecallQuestion[] = [];

    for (const level of levels ?? []) {
      const content = level.content_public as LessonContentPublic | null;
      if (!content?.steps) continue;

      const chapterData = level.chapters as { subject_id: string } | { subject_id: string }[];
      const subjectId = Array.isArray(chapterData)
        ? (chapterData[0]?.subject_id ?? "")
        : chapterData.subject_id;

      for (const step of content.steps) {
        if (step.type !== "recall") continue;
        allQuestions.push({
          levelId: level.id as string,
          questionKey: step.questionKey,
          question: step.question,
          options: step.options,
          subjectId,
          levelTitle: level.title_fr as string,
        });
      }
    }

    // Shuffle and pick up to count
    const shuffled = allQuestions.sort(() => Math.random() - 0.5);
    const questions = shuffled.slice(0, count);

    return NextResponse.json({ questions });
  } catch {
    return NextResponse.json({ error: "Internal error" }, { status: 500 });
  }
}
