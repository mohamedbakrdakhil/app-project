"use client";
import { useState } from "react";
import Card from "@/components/ui/Card";

type ReviewCard = {
  id: string;
  concept_key: string;
  concept_label: string;
  next_review_date: string;
};

interface ReviewSessionProps {
  cards: ReviewCard[];
}

const QUALITY_LABELS: Record<number, string> = {
  0: "Blackout",
  1: "Très difficile",
  2: "Difficile",
  3: "Correct",
  4: "Facile",
  5: "Très facile",
};

const QUALITY_COLORS: Record<number, { bg: string; text: string }> = {
  0: { bg: "rgba(255,85,85,0.85)", text: "#fff" },
  1: { bg: "rgba(255,120,60,0.85)", text: "#fff" },
  2: { bg: "rgba(255,180,50,0.85)", text: "#fff" },
  3: { bg: "rgba(60,200,120,0.85)", text: "#fff" },
  4: { bg: "rgba(30,180,220,0.85)", text: "#fff" },
  5: { bg: "rgba(100,120,255,0.85)", text: "#fff" },
};

export default function ReviewSession({ cards }: ReviewSessionProps) {
  const [queue] = useState<ReviewCard[]>(cards);
  const [current, setCurrent] = useState(0);
  const [loading, setLoading] = useState(false);
  const [done, setDone] = useState(false);
  const [showKey, setShowKey] = useState(false);

  const card = queue[current];
  const total = queue.length;
  const progress = total > 0 ? ((current) / total) * 100 : 0;

  const handleQuality = async (quality: number) => {
    if (!card) return;
    setLoading(true);
    await fetch("/api/reviews/submit", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ cardId: card.id, quality }),
    });
    setLoading(false);
    setShowKey(false);
    const next = current + 1;
    if (next >= queue.length) {
      setDone(true);
    } else {
      setCurrent(next);
    }
  };

  if (cards.length === 0) {
    return (
      <div className="text-center py-16 space-y-3">
        <div className="text-4xl">✅</div>
        <p className="font-semibold" style={{ color: "var(--text-primary)" }}>Pas de révision pour aujourd&apos;hui</p>
        <p className="text-sm" style={{ color: "var(--text-muted)" }}>Complète des leçons pour créer des cartes de révision.</p>
      </div>
    );
  }

  if (done) {
    return (
      <div className="text-center py-16 space-y-3">
        <div className="text-4xl">🎉</div>
        <p className="font-semibold" style={{ color: "var(--text-primary)" }}>Révisions terminées !</p>
        <p className="text-sm" style={{ color: "var(--text-muted)" }}>{queue.length} carte{queue.length > 1 ? "s" : ""} révisée{queue.length > 1 ? "s" : ""}.</p>
      </div>
    );
  }

  if (!card) return null;

  return (
    <div className="space-y-6">
      {/* Progress bar */}
      <div className="space-y-1">
        <div className="flex justify-between text-xs" style={{ color: "var(--text-muted)" }}>
          <span>{current + 1} / {total}</span>
          <span>{Math.round(progress)}%</span>
        </div>
        <div className="h-2 rounded-full overflow-hidden" style={{ backgroundColor: "var(--bg-card)" }}>
          <div
            className="h-full rounded-full transition-all"
            style={{ width: `${progress}%`, backgroundColor: "var(--anatomy)" }}
          />
        </div>
      </div>

      {/* Card */}
      <Card className="min-h-[200px] flex flex-col items-center justify-center gap-4 p-6">
        <p className="text-xl font-bold text-center" style={{ color: "var(--text-primary)" }}>
          {card.concept_label}
        </p>
        <button
          onClick={() => setShowKey(v => !v)}
          className="text-xs underline"
          style={{ color: "var(--text-muted)" }}
        >
          {showKey ? "Masquer" : "Voir"} la clé de concept
        </button>
        {showKey && (
          <p className="text-xs font-mono px-3 py-1 rounded-lg" style={{ backgroundColor: "var(--bg-card)", color: "var(--text-muted)", border: "1px solid var(--border-soft)" }}>
            {card.concept_key}
          </p>
        )}
      </Card>

      {/* Quality buttons */}
      <div>
        <p className="text-sm mb-3 text-center" style={{ color: "var(--text-secondary)" }}>Comment tu t&apos;en souviens ?</p>
        <div className="grid grid-cols-6 gap-1">
          {[0, 1, 2, 3, 4, 5].map((q) => {
            const colors = QUALITY_COLORS[q];
            return (
              <button
                key={q}
                onClick={() => handleQuality(q)}
                disabled={loading}
                className="flex flex-col items-center py-2 px-1 rounded-xl text-xs font-semibold transition-opacity disabled:opacity-50"
                style={{ backgroundColor: colors?.bg ?? "var(--bg-card)", color: colors?.text ?? "var(--text-primary)" }}
              >
                <span className="text-base font-bold">{q}</span>
                <span className="text-[10px] leading-tight text-center">{QUALITY_LABELS[q]}</span>
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
}
