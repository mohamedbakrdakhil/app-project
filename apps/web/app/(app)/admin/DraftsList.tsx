import Card from "@/components/ui/Card";

interface Draft {
  id: string;
  status: string;
  input_prompt: unknown;
  model_used: string | null;
  created_at: string;
  subject_id: string | null;
  chapter_id: string | null;
}

const STATUS_COLORS: Record<string, string> = {
  pending: "var(--text-muted)",
  generating: "var(--warning)",
  draft_review_required: "var(--xp-color)",
  approved: "var(--success)",
  rejected: "var(--error)",
  error: "var(--error)",
};

const STATUS_LABELS: Record<string, string> = {
  pending: "En attente",
  generating: "En cours...",
  draft_review_required: "À réviser",
  approved: "Approuvé",
  rejected: "Rejeté",
  error: "Erreur",
};

export default function DraftsList({ drafts }: { drafts: Draft[] }) {
  return (
    <Card className="space-y-4">
      <h2 className="font-semibold" style={{ color: "var(--text-secondary)" }}>Brouillons récents</h2>
      {drafts.length === 0 ? (
        <p className="text-sm" style={{ color: "var(--text-muted)" }}>Aucun brouillon pour l&apos;instant.</p>
      ) : (
        <div className="space-y-2">
          {drafts.map((d) => {
            const prompt = d.input_prompt as { concept?: string; level?: string } | null;
            return (
              <div key={d.id} className="flex items-center justify-between p-3 rounded-xl" style={{ backgroundColor: "var(--bg-secondary)" }}>
                <div className="space-y-0.5 flex-1 min-w-0">
                  <p className="text-sm font-medium truncate" style={{ color: "var(--text-primary)" }}>
                    {prompt?.concept ?? d.id}
                  </p>
                  <p className="text-xs" style={{ color: "var(--text-muted)" }}>
                    {new Date(d.created_at).toLocaleDateString("fr-FR")} · {d.model_used ?? "—"}
                  </p>
                </div>
                <span className="ml-3 text-xs font-semibold px-2 py-1 rounded-full flex-shrink-0" style={{ color: STATUS_COLORS[d.status] ?? "var(--text-muted)", backgroundColor: `${STATUS_COLORS[d.status] ?? "var(--text-muted)"}22` }}>
                  {STATUS_LABELS[d.status] ?? d.status}
                </span>
              </div>
            );
          })}
        </div>
      )}
    </Card>
  );
}
