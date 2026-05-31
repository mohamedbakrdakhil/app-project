"use client";
import { useState } from "react";
import type { ClinicalCaseStep } from "@masteri/core";
import Button from "@/components/ui/Button";

interface Props {
  step: ClinicalCaseStep;
  onAnswer: (questionKey: string, selectedIndex: number) => Promise<{ isCorrect: boolean; correctIndex: number; explanation: string; xpEarned: number }>;
  onNext: () => void;
}

export default function ClinicalCaseStepView({ step, onAnswer, onNext }: Props) {
  const [selected, setSelected] = useState<number | null>(null);
  const [feedback, setFeedback] = useState<{ isCorrect: boolean; correctIndex: number; explanation: string; xpEarned: number } | null>(null);
  const [loading, setLoading] = useState(false);

  const handleSelect = async (idx: number) => {
    if (feedback || loading) return;
    setSelected(idx);
    setLoading(true);
    try {
      const result = await onAnswer(step.questionKey, idx);
      setFeedback(result);
    } finally {
      setLoading(false);
    }
  };

  const difficultyColor = { easy: "var(--success)", medium: "var(--warning)", hard: "var(--error)" }[step.difficulty];

  return (
    <div className="space-y-5">
      <div className="flex items-center gap-2">
        <span className="text-lg">🏥</span>
        <span className="text-xs font-semibold px-2 py-0.5 rounded-full" style={{ backgroundColor: `${difficultyColor}20`, color: difficultyColor }}>
          Cas clinique · {step.difficulty === "easy" ? "Facile" : step.difficulty === "medium" ? "Moyen" : "Difficile"}
        </span>
        <span className="text-xs ml-auto" style={{ color: "var(--xp-color)" }}>+{step.xpReward} XP</span>
      </div>

      <div className="p-4 rounded-xl" style={{ backgroundColor: "rgba(0,212,255,0.06)", border: "1px solid rgba(0,212,255,0.2)" }}>
        <p className="text-sm leading-relaxed" style={{ color: "var(--text-secondary)" }}>{step.scenario}</p>
      </div>

      <p className="font-semibold" style={{ color: "var(--text-primary)" }}>{step.question}</p>

      <div className="space-y-2">
        {step.options.map((opt, idx) => {
          let style: React.CSSProperties = {
            backgroundColor: "var(--bg-card)",
            border: "1px solid var(--border-soft)",
            color: "var(--text-primary)",
            cursor: feedback ? "default" : "pointer",
          };
          if (feedback) {
            if (idx === feedback.correctIndex) style = { backgroundColor: "rgba(0,255,120,0.15)", border: "1px solid var(--success)", color: "var(--success)" };
            else if (idx === selected && !feedback.isCorrect) style = { backgroundColor: "rgba(255,85,85,0.15)", border: "1px solid var(--error)", color: "var(--error)" };
            else style = { backgroundColor: "var(--bg-card)", border: "1px solid var(--border-soft)", color: "var(--text-muted)", opacity: 0.5 };
          } else if (selected === idx) {
            style = { backgroundColor: "rgba(0,212,255,0.15)", border: "1px solid #00d4ff", color: "var(--text-primary)", cursor: "pointer" };
          }
          return (
            <button key={idx} onClick={() => handleSelect(idx)} disabled={!!feedback || loading} className="w-full text-left px-4 py-3 rounded-xl text-sm transition-all" style={style}>
              <span className="font-medium mr-2">{String.fromCharCode(65 + idx)}.</span>{opt}
            </button>
          );
        })}
      </div>

      {feedback && (
        <div className="space-y-3">
          <div className="p-4 rounded-xl" style={{ backgroundColor: feedback.isCorrect ? "rgba(0,255,120,0.1)" : "rgba(255,85,85,0.1)", border: `1px solid ${feedback.isCorrect ? "var(--success)" : "var(--error)"}` }}>
            <p className="font-semibold mb-1" style={{ color: feedback.isCorrect ? "var(--success)" : "var(--error)" }}>
              {feedback.isCorrect ? `✓ Bonne réponse ! +${feedback.xpEarned} XP` : "✗ Réponse incorrecte"}
            </p>
            <p className="text-sm" style={{ color: "var(--text-secondary)" }}>{feedback.explanation}</p>
          </div>
          <Button onClick={onNext} className="w-full">Continuer</Button>
        </div>
      )}
    </div>
  );
}
