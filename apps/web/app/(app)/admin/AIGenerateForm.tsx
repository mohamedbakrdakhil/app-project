"use client";
import { useState } from "react";
import Button from "@/components/ui/Button";
import Card from "@/components/ui/Card";

interface Subject { id: string; name_fr: string; }
interface Chapter { id: string; subject_id: string; title_fr: string; }

interface Props {
  subjects: Subject[];
  chapters: Chapter[];
  aiEnabled: boolean;
}

export default function AIGenerateForm({ subjects, chapters, aiEnabled }: Props) {
  const [subjectId, setSubjectId] = useState(subjects[0]?.id ?? "");
  const [chapterId, setChapterId] = useState("");
  const [concept, setConcept] = useState("");
  const [level, setLevel] = useState<"easy" | "medium" | "hard">("easy");
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<{ draftId: string; status: string } | null>(null);
  const [error, setError] = useState<string | null>(null);

  const filteredChapters = chapters.filter((c) => c.subject_id === subjectId);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!aiEnabled || !concept.trim() || !chapterId) return;
    setLoading(true);
    setError(null);
    setResult(null);
    try {
      const res = await fetch("/api/admin/ai/generate", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ subjectId, chapterId, concept: concept.trim(), level }),
      });
      const data = await res.json() as { draftId?: string; status?: string; error?: string };
      if (!res.ok) throw new Error(data.error ?? "Erreur");
      setResult({ draftId: data.draftId!, status: data.status! });
    } catch (e) {
      setError(e instanceof Error ? e.message : "Erreur inconnue");
    } finally {
      setLoading(false);
    }
  };

  const selectStyle: React.CSSProperties = {
    backgroundColor: "var(--bg-card)",
    border: "1px solid var(--border-soft)",
    color: "var(--text-primary)",
    borderRadius: "0.75rem",
    padding: "0.75rem 1rem",
    width: "100%",
    fontSize: "0.875rem",
  };

  return (
    <Card className="space-y-4">
      <h2 className="font-semibold" style={{ color: "var(--text-secondary)" }}>Générer un brouillon IA</h2>
      <form onSubmit={handleSubmit} className="space-y-4">
        <div className="space-y-2">
          <label className="text-sm" style={{ color: "var(--text-secondary)" }}>Matière</label>
          <select value={subjectId} onChange={(e) => { setSubjectId(e.target.value); setChapterId(""); }} style={selectStyle}>
            {subjects.map((s) => <option key={s.id} value={s.id}>{s.name_fr}</option>)}
          </select>
        </div>
        <div className="space-y-2">
          <label className="text-sm" style={{ color: "var(--text-secondary)" }}>Chapitre</label>
          <select value={chapterId} onChange={(e) => setChapterId(e.target.value)} style={selectStyle} required>
            <option value="">Choisir un chapitre...</option>
            {filteredChapters.map((c) => <option key={c.id} value={c.id}>{c.title_fr}</option>)}
          </select>
        </div>
        <div className="space-y-2">
          <label className="text-sm" style={{ color: "var(--text-secondary)" }}>Concept à enseigner</label>
          <input
            type="text"
            value={concept}
            onChange={(e) => setConcept(e.target.value)}
            placeholder="Ex: Os du carpe, Muscle biceps..."
            required
            style={{ ...selectStyle }}
          />
        </div>
        <div className="space-y-2">
          <label className="text-sm" style={{ color: "var(--text-secondary)" }}>Difficulté</label>
          <div className="flex gap-2">
            {(["easy", "medium", "hard"] as const).map((l) => (
              <button
                key={l}
                type="button"
                onClick={() => setLevel(l)}
                className="flex-1 py-2 rounded-xl text-sm font-medium transition-all"
                style={{
                  backgroundColor: level === l ? "var(--anatomy)" : "var(--bg-card)",
                  color: level === l ? "white" : "var(--text-secondary)",
                  border: `1px solid ${level === l ? "var(--anatomy)" : "var(--border-soft)"}`,
                }}
              >
                {l === "easy" ? "Facile" : l === "medium" ? "Moyen" : "Difficile"}
              </button>
            ))}
          </div>
        </div>
        {error && <p className="text-sm" style={{ color: "var(--error)" }}>{error}</p>}
        {result && (
          <div className="p-3 rounded-xl text-sm" style={{ backgroundColor: "rgba(0,255,120,0.1)", color: "var(--success)" }}>
            ✓ Brouillon créé — ID: {result.draftId} — Statut: {result.status}
          </div>
        )}
        <Button type="submit" loading={loading} disabled={!aiEnabled || !chapterId || !concept.trim()} className="w-full">
          {aiEnabled ? "Générer avec IA" : "IA non configurée"}
        </Button>
      </form>
    </Card>
  );
}
