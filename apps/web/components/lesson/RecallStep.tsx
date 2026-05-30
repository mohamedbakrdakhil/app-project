"use client";
import { useState } from "react";
import type { RecallStep } from "@masteri/core";
import TimerRing from "@/components/ui/TimerRing";
import Button from "@/components/ui/Button";

interface RecallStepProps {
  step: RecallStep;
  onAnswer: (questionKey: string, selectedIndex: number) => Promise<{ isCorrect: boolean; correctIndex: number; explanation: string; xpEarned: number }>;
  onNext: () => void;
}

type FeedbackState = {
  isCorrect: boolean;
  correctIndex: number;
  explanation: string;
  xpEarned: number;
};

export default function RecallStepView({ step, onAnswer, onNext }: RecallStepProps) {
  const [selected, setSelected] = useState<number | null>(null);
  const [feedback, setFeedback] = useState<FeedbackState | null>(null);
  const [loading, setLoading] = useState(false);
  const [, setTimerExpired] = useState(false);

  const handleSelect = async (idx: number) => {
    if (feedback ?? loading) return;
    setSelected(idx);
    setLoading(true);
    try {
      const result = await onAnswer(step.questionKey, idx);
      setFeedback(result);
    } catch {
      // ignore
    } finally {
      setLoading(false);
    }
  };

  const getOptionStyle = (idx: number): React.CSSProperties => {
    if (!feedback) {
      return {
        backgroundColor: selected === idx ? "rgba(255,77,109,0.2)" : "var(--bg-card)",
        border: `1px solid ${selected === idx ? "var(--anatomy)" : "var(--border-soft)"}`,
        color: "var(--text-primary)",
        cursor: "pointer",
      };
    }
    if (idx === feedback.correctIndex) {
      return { backgroundColor: "rgba(0,255,120,0.15)", border: "1px solid var(--success)", color: "var(--success)" };
    }
    if (idx === selected && !feedback.isCorrect) {
      return { backgroundColor: "rgba(255,85,85,0.15)", border: "1px solid var(--error)", color: "var(--error)" };
    }
    return { backgroundColor: "var(--bg-card)", border: "1px solid var(--border-soft)", color: "var(--text-muted)", opacity: 0.5 };
  };

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-start">
        <h2 className="text-lg font-semibold flex-1" style={{ color: "var(--text-primary)" }}>{step.question}</h2>
        {step.timerSeconds && !feedback && (
          <TimerRing totalSeconds={step.timerSeconds} onExpire={() => setTimerExpired(true)} />
        )}
      </div>
      <div className="space-y-3">
        {step.options.map((opt, idx) => (
          <button
            key={idx}
            onClick={() => handleSelect(idx)}
            disabled={!!feedback || loading}
            className="w-full text-left px-4 py-3 rounded-xl transition-all"
            style={getOptionStyle(idx)}
          >
            {opt}
          </button>
        ))}
      </div>
      {feedback && (
        <div className="space-y-3">
          <div className="p-4 rounded-xl" style={{ backgroundColor: feedback.isCorrect ? "rgba(0,255,120,0.1)" : "rgba(255,85,85,0.1)", border: `1px solid ${feedback.isCorrect ? "var(--success)" : "var(--error)"}` }}>
            <p className="font-semibold mb-1" style={{ color: feedback.isCorrect ? "var(--success)" : "var(--error)" }}>
              {feedback.isCorrect ? `✓ Correct ! +${feedback.xpEarned} XP` : "✗ Incorrect"}
            </p>
            <p className="text-sm" style={{ color: "var(--text-secondary)" }}>{feedback.explanation}</p>
          </div>
          <Button onClick={onNext} className="w-full">Continuer</Button>
        </div>
      )}
    </div>
  );
}
