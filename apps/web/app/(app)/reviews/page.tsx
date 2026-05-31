export const metadata = { title: "Révisions" };

import { redirect } from "next/navigation";
import { getSessionUser } from "@/lib/auth";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";
import ReviewSession from "./ReviewSession";

export default async function ReviewsPage() {
  const user = await getSessionUser();
  if (!user) redirect("/login");

  const admin = createSupabaseAdminClient();
  const today = new Date().toISOString().split("T")[0];
  const { data: cards } = await admin
    .from("spaced_rep_cards")
    .select("id, concept_key, concept_label, next_review_date")
    .eq("user_id", user.id)
    .lte("next_review_date", today)
    .order("next_review_date");

  return (
    <div className="space-y-6">
      <h1 className="text-xl font-bold" style={{ color: "var(--text-primary)" }}>Révisions</h1>
      <ReviewSession cards={cards ?? []} />
    </div>
  );
}
