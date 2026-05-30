import { NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";

export async function GET() {
  const supabase = await createSupabaseServerClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const admin = createSupabaseAdminClient();
  const { data: drafts } = await admin
    .from("ai_content_drafts")
    .select("id, status, input_prompt, model_used, created_at, subject_id, chapter_id")
    .order("created_at", { ascending: false })
    .limit(50);

  return NextResponse.json({ drafts: drafts ?? [] });
}
