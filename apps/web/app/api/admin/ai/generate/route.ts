import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";
import { generateLessonDraft } from "@/lib/ai/generate-content";
import { rateLimit } from "@/lib/rate-limit";

const GenerateBodySchema = z.object({
  subjectId: z.string().min(1),
  chapterId: z.string().uuid(),
  concept: z.string().min(2).max(100),
  level: z.enum(["easy", "medium", "hard"]).default("easy"),
});

export async function POST(request: NextRequest) {
  const supabase = await createSupabaseServerClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  // Rate limit: 5 AI generations per user per hour
  const rl = rateLimit(`ai_gen:${user.id}`, 5, 60 * 60 * 1000);
  if (!rl.allowed) {
    return NextResponse.json(
      { error: "Rate limit exceeded", retryAfterSeconds: rl.retryAfterSeconds },
      { status: 429, headers: { "Retry-After": String(rl.retryAfterSeconds) } },
    );
  }

  // Only allow if ANTHROPIC_API_KEY is configured
  if (!process.env.ANTHROPIC_API_KEY) {
    return NextResponse.json({ error: "AI generation not configured" }, { status: 503 });
  }

  try {
    const body = GenerateBodySchema.parse(await request.json());
    const admin = createSupabaseAdminClient();

    // Verify subject and chapter exist
    const { data: chapter } = await admin
      .from("chapters")
      .select("id, title_fr, subjects(name_fr)")
      .eq("id", body.chapterId)
      .eq("subject_id", body.subjectId)
      .single();

    if (!chapter) return NextResponse.json({ error: "Chapter not found" }, { status: 404 });

    const subjectName = (chapter.subjects as unknown as { name_fr: string } | null)?.name_fr ?? body.subjectId;
    const chapterName = chapter.title_fr;

    // Create draft record (generating)
    const { data: draft } = await admin
      .from("ai_content_drafts")
      .insert({
        created_by: user.id,
        subject_id: body.subjectId,
        chapter_id: body.chapterId,
        input_prompt: { concept: body.concept, level: body.level },
        status: "generating",
      })
      .select("id")
      .single();

    if (!draft) return NextResponse.json({ error: "Failed to create draft" }, { status: 500 });

    try {
      const result = await generateLessonDraft({
        subject: subjectName,
        chapter: chapterName,
        concept: body.concept,
        level: body.level,
        locale: "fr",
      });

      await admin.from("ai_content_drafts").update({
        content_public: result.contentPublic,
        answer_key: result.answerKey,
        status: "draft_review_required",
        model_used: result.modelUsed,
      }).eq("id", draft.id);

      return NextResponse.json({
        draftId: draft.id,
        status: "draft_review_required",
        contentPublic: result.contentPublic,
      });
    } catch (genError) {
      await admin.from("ai_content_drafts").update({
        status: "error",
        error_message: genError instanceof Error ? genError.message : "Unknown error",
      }).eq("id", draft.id);
      throw genError;
    }
  } catch (e) {
    if (e instanceof z.ZodError) return NextResponse.json({ error: "Invalid input", details: e.errors }, { status: 400 });
    console.error("AI generation error:", e);
    return NextResponse.json({ error: "Generation failed" }, { status: 500 });
  }
}
