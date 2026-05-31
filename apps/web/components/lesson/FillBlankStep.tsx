"use client";
import { useState } from "react";
import type { FillBlankStep } from "@masteri/core";
import Button from "@/components/ui/Button";

interface Props {
  step: FillBlankStep;
  onAnswer: (questionKey: string, textAnswer: string) => Promise<{ isCorrect: boolean; explanation: string; xpEarned: number }>;
  onNext: () => void;
}

export default function FillBlankStepView({ step, onAnswer, onNext }: Props) {
  const [text, setText] = useState("");
  const [feedback, setFeedback] = useState<{ isCorrect: boolean; explanation: string; xpEarned: number } | null>(null);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!text.trim() || loading || feedback) return;
    setLoading(true);
    try {
      const result = await onAnswer(step.questionKey, text.trim());
      setFeedback(result);
    } finally {
      setLoading(false);
    }
  };

  const renderPrompt = () => {
    return step.prompt.split("___").map((part, i, arr) => (
      <span key={i}>
        {part}
        {i < arr.length - 1 && (
          <span className="inline-block min-w-[80px] border-b-2 mx-1" style={{ borderColor: "var(--anatomy)" }}>
            {feedback ? <span style={{ color: feedback.isCorrect ? "var(--success)" : "var(--error)" }}>{text}</span> : null}
          </span>
        )}
      </span>
    ));
  };

  return (
    <div className="space-y-6">
      <p className="text-lg font-semibold leading-relaxed" style={{ color: "var(--text-primary)" }}>{renderPrompt()}</p>
      {step.hint && !feedback && (
        <p className="text-sm" style={{ color: "var(--text-muted)" }}>💡 {step.hint}</p>
      )}
      {!feedback ? (
        <form onSubmit={handleSubmit} className="space-y-4">
          <input
            type="text"
            value={text}
            onChange={(e) => setText(e.target.value)}
            aria-label="Ta réponse"
            placeholder="Ta réponse..."
            autoFocus
            className="w-full px-4 py-3 rounded-xl text-sm outline-none"
            style={{ backgroundColor: "var(--bg-card)", border: "1px solid var(--border-soft)", color: "var(--text-primary)" }}
          />
          <Button type="submit" loading={loading} disabled={!text.trim()} className="w-full">
            Valider
          </Button>
        </form>
      ) : (
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
