import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";

const ApproveBodySchema = z.object({
  slug: z.string().regex(/^[a-z0-9_]+$/),
  titleFr: z.string().min(1),
  orderIndex: z.number().int().positive(),
  difficulty: z.enum(["easy", "medium", "hard"]).default("easy"),
  xpReward: z.number().int().positive().default(100),
});

interface Props {
  params: Promise<{ draftId: string }>;
}

export async function POST(request: NextRequest, { params }: Props) {
  const supabase = await createSupabaseServerClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { draftId } = await params;

  try {
    const body = ApproveBodySchema.parse(await request.json());
    const admin = createSupabaseAdminClient();

    const { data: draft } = await admin
      .from("ai_content_drafts")
      .select("id, chapter_id, content_public, answer_key, status")
      .eq("id", draftId)
      .eq("status", "draft_review_required")
      .single();

    if (!draft) return NextResponse.json({ error: "Draft not found or not in review state" }, { status: 404 });

    // Create the actual level
    const { data: level } = await admin
      .from("levels")
      .insert({
        chapter_id: draft.chapter_id,
        slug: body.slug,
        title_fr: body.titleFr,
        order_index: body.orderIndex,
        difficulty: body.difficulty,
        xp_reward: body.xpReward,
        content_public: draft.content_public,
        content_version: 1,
        content_status: "reviewed",
        is_published: true,
      })
      .select("id")
      .single();

    if (!level) return NextResponse.json({ error: "Failed to create level" }, { status: 500 });

    // Insert answer key
    await admin.from("level_answer_keys").insert({
      level_id: level.id,
      answers: draft.answer_key,
    });

    // Mark draft as approved
    await admin.from("ai_content_drafts").update({ status: "approved" }).eq("id", draftId);

    return NextResponse.json({ levelId: level.id, status: "approved" });
  } catch (e) {
    if (e instanceof z.ZodError) return NextResponse.json({ error: "Invalid input" }, { status: 400 });
    return NextResponse.json({ error: "Internal error" }, { status: 500 });
  }
}
