import { redirect } from "next/navigation";
import { getSessionUser } from "@/lib/auth";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";
import AIGenerateForm from "./AIGenerateForm";
import DraftsList from "./DraftsList";

export default async function AdminPage() {
  const user = await getSessionUser();
  if (!user) redirect("/login");

  const admin = createSupabaseAdminClient();

  const [{ data: subjects }, { data: chapters }, { data: drafts }] = await Promise.all([
    admin.from("subjects").select("id, name_fr").eq("is_published", true),
    admin.from("chapters").select("id, subject_id, title_fr").eq("is_published", true).order("order_index"),
    admin.from("ai_content_drafts").select("id, status, input_prompt, model_used, created_at, subject_id, chapter_id").order("created_at", { ascending: false }).limit(20),
  ]);

  const aiEnabled = !!process.env.ANTHROPIC_API_KEY;

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
    </div>
  );
}
