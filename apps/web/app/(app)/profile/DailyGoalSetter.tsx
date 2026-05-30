"use client";
import { useState } from "react";
import Button from "@/components/ui/Button";

interface Props {
  currentGoal: number;
}

const GOAL_OPTIONS = [3, 5, 10, 15, 20];

export default function DailyGoalSetter({ currentGoal }: Props) {
  const [selected, setSelected] = useState(currentGoal);
  const [loading, setLoading] = useState(false);
  const [saved, setSaved] = useState(false);

  const handleSave = async () => {
    setLoading(true);
    await fetch("/api/profile/goal", {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ dailyGoal: selected }),
    });
    setLoading(false);
    setSaved(true);
    setTimeout(() => setSaved(false), 2000);
  };

  return (
    <div className="space-y-3">
      <p className="text-sm font-medium" style={{ color: "var(--text-secondary)" }}>Objectif quotidien (niveaux/jour)</p>
      <div className="flex gap-2 flex-wrap">
        {GOAL_OPTIONS.map((g) => (
          <button
            key={g}
            onClick={() => setSelected(g)}
            className="px-4 py-2 rounded-xl text-sm font-semibold transition-all"
            style={{
              backgroundColor: selected === g ? "var(--anatomy)" : "var(--bg-card)",
              color: selected === g ? "white" : "var(--text-secondary)",
              border: `1px solid ${selected === g ? "var(--anatomy)" : "var(--border-soft)"}`,
            }}
          >
            {g}
          </button>
        ))}
      </div>
      <Button onClick={handleSave} loading={loading} variant="secondary" className="w-full">
        {saved ? "✓ Enregistré" : "Sauvegarder"}
      </Button>
    </div>
  );
}
