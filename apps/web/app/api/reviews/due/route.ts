import { NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";

export async function GET() {
  const supabase = await createSupabaseServerClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const admin = createSupabaseAdminClient();
  const today = new Date().toISOString().split("T")[0];
  const { data: cards } = await admin
    .from("spaced_rep_cards")
    .select("id, concept_key, concept_label, ease_factor, interval_days, repetitions, next_review_date")
    .eq("user_id", user.id)
    .lte("next_review_date", today)
    .order("next_review_date", { ascending: true });

  return NextResponse.json({ cards: cards ?? [] });
}
