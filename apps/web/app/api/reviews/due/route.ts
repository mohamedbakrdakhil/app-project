import { NextRequest, NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";

export async function GET(request: NextRequest) {
  const supabase = await createSupabaseServerClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const admin = createSupabaseAdminClient();
  const today = new Date().toISOString().split("T")[0]!;
  const subjectId = request.nextUrl.searchParams.get("subject");

  let query = admin
    .from("spaced_rep_cards")
    .select("id, concept_key, concept_label, ease_factor, interval_days, repetitions, next_review_date, level_id")
    .eq("user_id", user.id)
    .lte("next_review_date", today)
    .order("next_review_date", { ascending: true });

  if (subjectId) {
    // Filter by fetching chapter IDs for the subject, then level IDs
    const { data: chapters } = await admin
      .from("chapters")
      .select("id")
      .eq("subject_id", subjectId);
    const chapterIds = (chapters ?? []).map((c) => c.id);
    if (chapterIds.length === 0) return NextResponse.json({ cards: [] });

    const { data: levels } = await admin
      .from("levels")
      .select("id")
      .in("chapter_id", chapterIds);
    const levelIds = (levels ?? []).map((l) => l.id);
    if (levelIds.length === 0) return NextResponse.json({ cards: [] });

    query = query.in("level_id", levelIds);
  }

  const { data: cards } = await query;
  return NextResponse.json({ cards: cards ?? [] });
}
