"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import Button from "@/components/ui/Button";

const SUBJECTS = [
  { id: "anatomy", name: "Anatomie", icon: "🫀", color: "#ff4d6d" },
  { id: "physiology", name: "Physiologie", icon: "❤️", color: "#00d4ff" },
  { id: "histology", name: "Histologie", icon: "🔬", color: "#aa77ff" },
  { id: "pharmacology", name: "Pharmacologie", icon: "💊", color: "#ffb347" },
  { id: "pathology", name: "Pathologie", icon: "🧫", color: "#ff6b35" },
  { id: "biochemistry", name: "Biochimie", icon: "⚗️", color: "#00ff99" },
];

const GOALS = [
  { value: 3, label: "Détendu", desc: "3 niveaux/jour" },
  { value: 5, label: "Régulier", desc: "5 niveaux/jour" },
  { value: 10, label: "Intensif", desc: "10 niveaux/jour" },
];

export default function OnboardingPage() {
  const router = useRouter();
  const [step, setStep] = useState<"subjects" | "goal">("subjects");
  const [selected, setSelected] = useState<string[]>([]);
  const [goal, setGoal] = useState(5);
  const [loading, setLoading] = useState(false);

  const toggleSubject = (id: string) => {
    setSelected((prev) => prev.includes(id) ? prev.filter((s) => s !== id) : [...prev, id]);
  };

  const handleComplete = async () => {
    setLoading(true);
    await fetch("/api/onboarding/complete", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ dailyGoal: goal, preferredSubjects: selected }),
    });
    router.push("/home");
    router.refresh();
  };

  return (
    <div className="min-h-screen flex flex-col items-center justify-center p-6" style={{ backgroundColor: "var(--bg-primary)" }}>
      <div className="w-full max-w-sm space-y-8">
        {step === "subjects" && (
          <>
            <div className="text-center space-y-2">
              <div className="text-5xl mb-4">🎓</div>
              <h1 className="text-2xl font-bold" style={{ color: "var(--text-primary)" }}>Bienvenue sur Masteri</h1>
              <p className="text-sm" style={{ color: "var(--text-muted)" }}>Quelles matières veux-tu maîtriser ?</p>
            </div>
            <div className="grid grid-cols-2 gap-3">
              {SUBJECTS.map((s) => {
                const isSelected = selected.includes(s.id);
                return (
                  <button
                    key={s.id}
                    onClick={() => toggleSubject(s.id)}
                    className="p-4 rounded-2xl text-left transition-all"
                    style={{
                      backgroundColor: isSelected ? `${s.color}20` : "var(--bg-card)",
                      border: `2px solid ${isSelected ? s.color : "var(--border-soft)"}`,
                    }}
                  >
                    <div className="text-2xl mb-1">{s.icon}</div>
                    <div className="text-sm font-semibold" style={{ color: isSelected ? s.color : "var(--text-primary)" }}>{s.name}</div>
                  </button>
                );
              })}
            </div>
            <Button onClick={() => setStep("goal")} className="w-full" disabled={selected.length === 0}>
              Continuer →
            </Button>
            <button onClick={() => { setSelected(SUBJECTS.map((s) => s.id)); setStep("goal"); }} className="w-full text-sm" style={{ color: "var(--text-muted)" }}>
              Tout sélectionner et continuer
            </button>
          </>
        )}

        {step === "goal" && (
          <>
            <div className="text-center space-y-2">
              <div className="text-5xl mb-4">🎯</div>
              <h2 className="text-2xl font-bold" style={{ color: "var(--text-primary)" }}>Ton objectif quotidien</h2>
              <p className="text-sm" style={{ color: "var(--text-muted)" }}>Combien de niveaux par jour ?</p>
            </div>
            <div className="space-y-3">
              {GOALS.map((g) => (
                <button
                  key={g.value}
                  onClick={() => setGoal(g.value)}
                  className="w-full p-4 rounded-2xl text-left transition-all"
                  style={{
                    backgroundColor: goal === g.value ? "rgba(255,77,109,0.1)" : "var(--bg-card)",
                    border: `2px solid ${goal === g.value ? "var(--anatomy)" : "var(--border-soft)"}`,
                  }}
                >
                  <div className="font-semibold" style={{ color: goal === g.value ? "var(--anatomy)" : "var(--text-primary)" }}>{g.label}</div>
                  <div className="text-sm" style={{ color: "var(--text-muted)" }}>{g.desc}</div>
                </button>
              ))}
            </div>
            <Button onClick={handleComplete} loading={loading} className="w-full">
              Commencer Masteri 🚀
            </Button>
          </>
        )}
      </div>
    </div>
  );
}
