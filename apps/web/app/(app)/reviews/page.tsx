export const metadata = { title: "Révisions" };
export const dynamic = "force-dynamic";

import { redirect } from "next/navigation";
import { getSessionUser } from "@/lib/auth";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";
import ReviewSession from "./ReviewSession";
import Link from "next/link";

interface Props {
  searchParams: Promise<{ subject?: string }>;
}

export default async function ReviewsPage({ searchParams }: Props) {
  const { subject } = await searchParams;
  const user = await getSessionUser();
  if (!user) redirect("/login");

  const admin = createSupabaseAdminClient();
  const today = new Date().toISOString().split("T")[0]!;

  const [subjectsRes, cardsQueryBase] = await Promise.all([
    admin.from("subjects").select("id, name_fr, icon, color").eq("is_published", true).order("order_index"),
    Promise.resolve(null),
  ]);
  void cardsQueryBase;

  const subjects = subjectsRes.data ?? [];

  let cardsQuery = admin
    .from("spaced_rep_cards")
    .select("id, concept_key, concept_label, next_review_date")
    .eq("user_id", user.id)
    .lte("next_review_date", today)
    .order("next_review_date");

  if (subject) {
    const { data: chapters } = await admin
      .from("chapters")
      .select("id")
      .eq("subject_id", subject);
    const chapterIds = (chapters ?? []).map((c) => c.id);
    if (chapterIds.length > 0) {
      const { data: levels } = await admin
        .from("levels")
        .select("id")
        .in("chapter_id", chapterIds);
      const levelIds = (levels ?? []).map((l) => l.id);
      if (levelIds.length > 0) {
        cardsQuery = cardsQuery.in("level_id", levelIds) as typeof cardsQuery;
      }
    }
  }

  const { data: cards } = await cardsQuery;

  return (
    <div className="space-y-6">
      <h1 className="text-xl font-bold" style={{ color: "var(--text-primary)" }}>Révisions</h1>

      <div className="flex gap-2 overflow-x-auto pb-1">
        <Link
          href="/reviews"
          className="px-3 py-1 rounded-full text-sm font-medium whitespace-nowrap transition-colors"
          style={{
            backgroundColor: !subject ? "var(--anatomy)" : "var(--bg-secondary)",
            color: !subject ? "white" : "var(--text-secondary)",
          }}
        >
          Tout
        </Link>
        {subjects.map((s) => (
          <Link
            key={s.id}
            href={`/reviews?subject=${s.id}`}
            className="px-3 py-1 rounded-full text-sm font-medium whitespace-nowrap transition-colors"
            style={{
              backgroundColor: subject === s.id ? (s.color ?? "var(--anatomy)") : "var(--bg-secondary)",
              color: subject === s.id ? "white" : "var(--text-secondary)",
            }}
          >
            {s.icon} {s.name_fr}
          </Link>
        ))}
      </div>

      <ReviewSession cards={cards ?? []} />
    </div>
  );
}
