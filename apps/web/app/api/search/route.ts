import { NextRequest, NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";

export const dynamic = "force-dynamic";

export async function GET(request: NextRequest) {
  const supabase = await createSupabaseServerClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const q = request.nextUrl.searchParams.get("q")?.trim() ?? "";
  if (q.length < 2) return NextResponse.json({ results: [] });

  const admin = createSupabaseAdminClient();

  const [{ data: subjects }, { data: levels }] = await Promise.all([
    admin.from("subjects")
      .select("id, name_fr, icon, color")
      .eq("is_published", true)
      .ilike("name_fr", `%${q}%`)
      .limit(3),
    admin.from("levels")
      .select("id, title_fr, chapter_id")
      .eq("is_published", true)
      .ilike("title_fr", `%${q}%`)
      .limit(6),
  ]);

  const results = [
    ...(subjects ?? []).map((s) => ({ type: "subject" as const, id: s.id, title: s.name_fr, icon: s.icon ?? "📚", href: `/subject/${s.id}` })),
    ...(levels ?? []).map((l) => ({ type: "level" as const, id: l.id, title: l.title_fr, icon: "📖", href: `/lesson/${l.id}` })),
  ];

  return NextResponse.json({ results });
}
