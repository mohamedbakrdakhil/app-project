"use client";
import { useState, useCallback } from "react";
import type { LessonContentPublic, RecallStep } from "@masteri/core";
import IntroStepView from "./IntroStep";
import RecallStepView from "./RecallStep";
import CompleteStepView from "./CompleteStep";

interface LessonPlayerProps {
  levelId: string;
}

type Phase = "loading" | "playing" | "summary" | "error";

interface AttemptState {
  attemptId: string;
  content: LessonContentPublic;
}

interface SummaryState {
  scorePercent: number;
  xpEarned: number;
  isCompleted: boolean;
  isPerfect: boolean;
  masteredConcepts: string[];
}

export default function LessonPlayer({ levelId }: LessonPlayerProps) {
  const [phase, setPhase] = useState<Phase>("loading");
  const [attempt, setAttempt] = useState<AttemptState | null>(null);
  const [stepIndex, setStepIndex] = useState(0);
  const [error, setError] = useState<string | null>(null);
  const [summary, setSummary] = useState<SummaryState | null>(null);
  const [started, setStarted] = useState(false);

  const startLesson = useCallback(async () => {
    setStarted(true);
    try {
      const res = await fetch("/api/lesson/start", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ levelId }),
      });
      if (!res.ok) throw new Error("Impossible de démarrer la leçon");
      const data = await res.json() as { attemptId: string; level: { contentPublic: LessonContentPublic } };
      setAttempt({ attemptId: data.attemptId, content: data.level.contentPublic });
      setPhase("playing");
    } catch (e) {
      setError(e instanceof Error ? e.message : "Erreur inconnue");
      setPhase("error");
    }
  }, [levelId]);

  // Auto-start on mount
  if (!started && phase === "loading") {
    startLesson();
  }

  const handleRecallAnswer = useCallback(async (questionKey: string, selectedIndex: number): Promise<{ isCorrect: boolean; correctIndex: number; explanation: string; xpEarned: number }> => {
    if (!attempt) throw new Error("No attempt");
    const res = await fetch("/api/lesson/answer", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ attemptId: attempt.attemptId, stepIndex, questionKey, selectedIndex }),
    });
    if (!res.ok) throw new Error("Erreur de validation");
    return res.json();
  }, [attempt, stepIndex]);

  const completeLesson = useCallback(async () => {
    if (!attempt) return;
    try {
      const res = await fetch("/api/lesson/complete", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ attemptId: attempt.attemptId }),
      });
      if (!res.ok) throw new Error("Erreur de complétion");
      const data = await res.json() as SummaryState;
      setSummary(data);
      setPhase("summary");
    } catch (e) {
      setError(e instanceof Error ? e.message : "Erreur");
      setPhase("error");
    }
  }, [attempt]);

  const handleNext = useCallback(() => {
    if (!attempt) return;
    const nextIndex = stepIndex + 1;
    if (nextIndex >= attempt.content.steps.length) {
      completeLesson();
    } else {
      setStepIndex(nextIndex);
    }
  }, [attempt, stepIndex, completeLesson]);

  if (phase === "loading") {
    return <div className="flex items-center justify-center h-64 text-lg" style={{ color: "var(--text-muted)" }}>Chargement...</div>;
  }
  if (phase === "error") {
    return <div className="p-4 rounded-xl text-center" style={{ color: "var(--error)", backgroundColor: "rgba(255,85,85,0.1)" }}>{error}</div>;
  }
  if (phase === "summary" && summary) {
    return (
      <div className="space-y-6 p-4">
        <div className="text-center space-y-2">
          <div className="text-5xl">{summary.isPerfect ? "🏆" : summary.isCompleted ? "✅" : "📚"}</div>
          <h2 className="text-2xl font-bold" style={{ color: "var(--text-primary)" }}>
            {summary.isCompleted ? "Leçon terminée !" : "Continue à réviser"}
          </h2>
          <p style={{ color: "var(--text-secondary)" }}>Score : {summary.scorePercent}%</p>
          <p style={{ color: "var(--xp-color)" }}>+{summary.xpEarned} XP</p>
        </div>
        {summary.masteredConcepts.length > 0 && (
          <div>
            <h3 className="font-semibold mb-2" style={{ color: "var(--text-secondary)" }}>Concepts maîtrisés</h3>
            <ul className="space-y-1">
              {summary.masteredConcepts.map((c) => (
                <li key={c} className="text-sm px-3 py-1 rounded-lg" style={{ backgroundColor: "rgba(0,255,120,0.1)", color: "var(--success)" }}>✓ {c}</li>
              ))}
            </ul>
          </div>
        )}
        <a href="/home" className="block w-full text-center px-4 py-3 rounded-xl font-semibold text-white" style={{ backgroundColor: "var(--anatomy)" }}>
          Retour à l&apos;accueil
        </a>
      </div>
    );
  }

  if (!attempt) return null;
  const step = attempt.content.steps[stepIndex];
  if (!step) return null;
  const progress = (stepIndex / attempt.content.steps.length) * 100;

  return (
    <div className="space-y-4">
      <div className="h-2 rounded-full overflow-hidden" style={{ backgroundColor: "var(--bg-card)" }}>
        <div className="h-full rounded-full transition-all" style={{ width: `${progress}%`, backgroundColor: "var(--anatomy)" }} />
      </div>
      {step.type === "intro" && <IntroStepView step={step} onNext={handleNext} />}
      {step.type === "recall" && (
        <RecallStepWrapper
          step={step}
          onAnswer={handleRecallAnswer}
          onNext={handleNext}
        />
      )}
      {step.type === "complete" && <CompleteStepView step={step} onNext={handleNext} />}
    </div>
  );
}

function RecallStepWrapper({ step, onAnswer, onNext }: {
  step: RecallStep;
  onAnswer: (questionKey: string, selectedIndex: number) => Promise<{ isCorrect: boolean; correctIndex: number; explanation: string; xpEarned: number }>;
  onNext: () => void;
}) {
  return <RecallStepView step={step} onAnswer={onAnswer} onNext={onNext} />;
}
