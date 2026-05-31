import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export const dynamic = "force-dynamic";

const BookmarkBodySchema = z.object({
  levelId: z.string().uuid(),
});

export async function GET() {
  const supabase = await createSupabaseServerClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { data: bookmarks, error } = await supabase
    .from("bookmarked_levels")
    .select("level_id, created_at, levels(title_fr, chapters(subject_id))")
    .eq("user_id", user.id)
    .order("created_at", { ascending: false });

  if (error) return NextResponse.json({ error: "Internal error" }, { status: 500 });

  type LevelJoin = { title_fr: string; chapters: { subject_id: string } | { subject_id: string }[] | null };
  const result = (bookmarks ?? []).map((b) => {
    const level = b.levels as unknown as LevelJoin | null;
    const chapters = level?.chapters;
    const subjectId = Array.isArray(chapters)
      ? (chapters[0]?.subject_id ?? "")
      : (chapters?.subject_id ?? "");
    return {
      levelId: b.level_id,
      title: level?.title_fr ?? "",
      subjectId,
      createdAt: b.created_at,
    };
  });

  return NextResponse.json({ bookmarks: result });
}

export async function POST(request: NextRequest) {
  try {
    const supabase = await createSupabaseServerClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    const body = BookmarkBodySchema.parse(await request.json());

    const { error } = await supabase
      .from("bookmarked_levels")
      .upsert({ user_id: user.id, level_id: body.levelId }, { onConflict: "user_id,level_id", ignoreDuplicates: true });

    if (error) return NextResponse.json({ error: "Internal error" }, { status: 500 });

    return NextResponse.json({ bookmarked: true });
  } catch (e) {
    if (e instanceof z.ZodError) return NextResponse.json({ error: "Invalid input" }, { status: 400 });
    return NextResponse.json({ error: "Internal error" }, { status: 500 });
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const supabase = await createSupabaseServerClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    const body = BookmarkBodySchema.parse(await request.json());

    const { error } = await supabase
      .from("bookmarked_levels")
      .delete()
      .eq("user_id", user.id)
      .eq("level_id", body.levelId);

    if (error) return NextResponse.json({ error: "Internal error" }, { status: 500 });

    return NextResponse.json({ bookmarked: false });
  } catch (e) {
    if (e instanceof z.ZodError) return NextResponse.json({ error: "Invalid input" }, { status: 400 });
    return NextResponse.json({ error: "Internal error" }, { status: 500 });
  }
}
