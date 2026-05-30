"use client";
import { useState } from "react";
import Card from "@/components/ui/Card";
import Button from "@/components/ui/Button";

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

export default function ReviewSession({ cards }: ReviewSessionProps) {
  const [queue] = useState<ReviewCard[]>(cards);
  const [current, setCurrent] = useState(0);
  const [loading, setLoading] = useState(false);
  const [done, setDone] = useState(false);

  const card = queue[current];

  const handleQuality = async (quality: number) => {
    if (!card) return;
    setLoading(true);
    await fetch("/api/reviews/submit", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ cardId: card.id, quality }),
    });
    setLoading(false);
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
      <p className="text-sm" style={{ color: "var(--text-muted)" }}>{current + 1} / {queue.length}</p>
      <Card className="min-h-[200px] flex items-center justify-center">
        <p className="text-lg font-semibold text-center" style={{ color: "var(--text-primary)" }}>{card.concept_label}</p>
      </Card>
      <div>
        <p className="text-sm mb-3 text-center" style={{ color: "var(--text-secondary)" }}>Comment tu t&apos;en souviens ?</p>
        <div className="grid grid-cols-3 gap-2">
          {[0, 1, 2, 3, 4, 5].map((q) => (
            <Button
              key={q}
              variant={q >= 3 ? "primary" : "secondary"}
              onClick={() => handleQuality(q)}
              loading={loading}
              className="text-xs py-2"
            >
              {QUALITY_LABELS[q]}
            </Button>
          ))}
        </div>
      </div>
    </div>
  );
}
