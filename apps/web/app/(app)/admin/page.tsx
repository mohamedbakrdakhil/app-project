export const metadata = { title: "Administration" };
export const dynamic = "force-dynamic";

import { redirect } from "next/navigation";
import { getSessionUser } from "@/lib/auth";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";
import AIGenerateForm from "./AIGenerateForm";
import DraftsList from "./DraftsList";

export default async function AdminPage() {
  const user = await getSessionUser();
  if (!user) redirect("/login");

  const admin = createSupabaseAdminClient();

  const [
    { data: subjects },
    { data: chapters },
    { data: drafts },
    { data: reportsByStatus },
    { data: pendingReports },
    { count: profilesCount },
    { count: badgesCount },
    { count: attemptsCount },
    { data: attemptedLevels },
  ] = await Promise.all([
    admin.from("subjects").select("id, name_fr").eq("is_published", true),
    admin.from("chapters").select("id, subject_id, title_fr").eq("is_published", true).order("order_index"),
    admin.from("ai_content_drafts").select("id, status, input_prompt, model_used, created_at, subject_id, chapter_id").order("created_at", { ascending: false }).limit(20),
    admin.from("content_reports").select("status"),
    admin.from("content_reports").select("id, level_id, reason, created_at").eq("status", "pending").order("created_at", { ascending: false }).limit(5),
    admin.from("profiles").select("*", { count: "exact", head: true }),
    admin.from("user_badges").select("*", { count: "exact", head: true }),
    admin.from("lesson_attempts").select("*", { count: "exact", head: true }),
    admin.from("lesson_attempts").select("level_id"),
  ]);

  const aiEnabled = !!process.env.ANTHROPIC_API_KEY;

  // Compute report counts by status
  const reportStatusCounts = (reportsByStatus ?? []).reduce<Record<string, number>>((acc, r) => {
    const s = r.status as string;
    acc[s] = (acc[s] ?? 0) + 1;
    return acc;
  }, {});

  // Compute attempted levels count (unique level_ids)
  const uniqueAttemptedLevels = new Set((attemptedLevels ?? []).map((a) => a.level_id)).size;

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-xl font-bold" style={{ color: "var(--text-primary)" }}>Administration</h1>
        <p className="text-sm" style={{ color: "var(--text-muted)" }}>Génération de contenu IA et gestion des brouillons</p>
      </div>

      {!aiEnabled && (
        <div className="p-4 rounded-xl" style={{ backgroundColor: "rgba(255,179,71,0.1)", border: "1px solid rgba(255,179,71,0.3)" }}>
          <p className="text-sm" style={{ color: "var(--warning)" }}>⚠️ ANTHROPIC_API_KEY non configurée — la génération IA est désactivée.</p>
        </div>
      )}

      <AIGenerateForm
        subjects={subjects ?? []}
        chapters={chapters ?? []}
        aiEnabled={aiEnabled}
      />

      <DraftsList drafts={drafts ?? []} />

      {/* Content Reports */}
      <section className="space-y-4">
        <h2 className="text-lg font-semibold" style={{ color: "var(--text-primary)" }}>Signalements de contenu</h2>
        <div className="flex gap-4 flex-wrap">
          {(["pending", "reviewed", "resolved"] as const).map((s) => (
            <div key={s} className="p-4 rounded-xl flex-1 min-w-[120px]" style={{ backgroundColor: "var(--surface-2)", border: "1px solid var(--border)" }}>
              <p className="text-xs uppercase" style={{ color: "var(--text-muted)" }}>{s}</p>
              <p className="text-2xl font-bold mt-1" style={{ color: "var(--text-primary)" }}>{reportStatusCounts[s] ?? 0}</p>
            </div>
          ))}
        </div>
        {(pendingReports ?? []).length > 0 && (
          <div className="space-y-2">
            <p className="text-sm font-medium" style={{ color: "var(--text-muted)" }}>Derniers signalements en attente</p>
            {(pendingReports ?? []).map((r) => (
              <div key={r.id} className="p-3 rounded-lg text-sm" style={{ backgroundColor: "var(--surface-2)", border: "1px solid var(--border)" }}>
                <span style={{ color: "var(--text-primary)" }}>{r.reason}</span>
                <span className="ml-2 text-xs" style={{ color: "var(--text-muted)" }}>niveau : {r.level_id}</span>
              </div>
            ))}
          </div>
        )}
      </section>

      {/* User Stats */}
      <section className="space-y-4">
        <h2 className="text-lg font-semibold" style={{ color: "var(--text-primary)" }}>Statistiques utilisateurs</h2>
        <div className="flex gap-4 flex-wrap">
          {[
            { label: "Profils", value: profilesCount },
            { label: "Badges attribués", value: badgesCount },
            { label: "Tentatives de cours", value: attemptsCount },
          ].map(({ label, value }) => (
            <div key={label} className="p-4 rounded-xl flex-1 min-w-[140px]" style={{ backgroundColor: "var(--surface-2)", border: "1px solid var(--border)" }}>
              <p className="text-xs uppercase" style={{ color: "var(--text-muted)" }}>{label}</p>
              <p className="text-2xl font-bold mt-1" style={{ color: "var(--text-primary)" }}>{value ?? 0}</p>
            </div>
          ))}
        </div>
      </section>

      {/* Level Coverage */}
      <section className="space-y-4">
        <h2 className="text-lg font-semibold" style={{ color: "var(--text-primary)" }}>Couverture des niveaux</h2>
        <div className="p-4 rounded-xl" style={{ backgroundColor: "var(--surface-2)", border: "1px solid var(--border)" }}>
          <p className="text-xs uppercase" style={{ color: "var(--text-muted)" }}>Niveaux ayant été tentés</p>
          <p className="text-2xl font-bold mt-1" style={{ color: "var(--text-primary)" }}>{uniqueAttemptedLevels}</p>
        </div>
      </section>
    </div>
  );
}
