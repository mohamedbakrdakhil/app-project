import type { IntroStep } from "@masteri/core";
import Button from "@/components/ui/Button";

interface IntroStepProps {
  step: IntroStep;
  onNext: () => void;
}

export default function IntroStepView({ step, onNext }: IntroStepProps) {
  return (
    <div className="space-y-6">
      <div className="space-y-2">
        <h1 className="text-2xl font-bold" style={{ color: "var(--text-primary)" }}>{step.title}</h1>
        {step.subtitle && <p className="text-sm font-medium" style={{ color: "var(--anatomy)" }}>{step.subtitle}</p>}
      </div>
      {step.visual?.type === "placeholder" && (
        <div className="h-32 rounded-2xl flex items-center justify-center text-4xl" style={{ backgroundColor: "var(--bg-card)", border: "1px solid var(--border-soft)" }}>
          🦴
        </div>
      )}
      <p className="leading-relaxed" style={{ color: "var(--text-secondary)" }}>{step.body}</p>
      {step.fact && (
        <div className="p-4 rounded-xl" style={{ backgroundColor: "rgba(255,179,71,0.1)", border: "1px solid rgba(255,179,71,0.3)" }}>
          <p className="text-sm" style={{ color: "var(--xp-color)" }}>💡 {step.fact}</p>
        </div>
      )}
      <Button onClick={onNext} className="w-full">Continuer</Button>
    </div>
  );
}
