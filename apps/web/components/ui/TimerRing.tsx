"use client";
import { useEffect, useState } from "react";

interface TimerRingProps {
  totalSeconds: number;
  onExpire?: () => void;
}

export default function TimerRing({ totalSeconds, onExpire }: TimerRingProps) {
  const [remaining, setRemaining] = useState(totalSeconds);

  useEffect(() => {
    setRemaining(totalSeconds);
  }, [totalSeconds]);

  useEffect(() => {
    if (remaining <= 0) {
      onExpire?.();
      return;
    }
    const t = setTimeout(() => setRemaining((r) => r - 1), 1000);
    return () => clearTimeout(t);
  }, [remaining, onExpire]);

  const pct = (remaining / totalSeconds) * 100;
  const color = pct > 50 ? "var(--success)" : pct > 25 ? "var(--warning)" : "var(--error)";

  return (
    <div className="flex items-center gap-2 text-sm font-mono" style={{ color }}>
      <span>⏱</span>
      <span>{remaining}s</span>
    </div>
  );
}
