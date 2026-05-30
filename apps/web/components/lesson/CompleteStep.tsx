import type { CompleteStep } from "@masteri/core";
import Button from "@/components/ui/Button";

interface CompleteStepProps {
  step: CompleteStep;
  onNext: () => void;
}

export default function CompleteStepView({ step, onNext }: CompleteStepProps) {
  return (
    <div className="space-y-6 text-center">
      <div className="text-5xl">🎉</div>
      <div>
        <h2 className="text-2xl font-bold mb-2" style={{ color: "var(--text-primary)" }}>{step.title}</h2>
        <p style={{ color: "var(--text-secondary)" }}>{step.body}</p>
      </div>
      {step.masteredConcepts.length > 0 && (
        <div className="text-left space-y-2">
          <p className="text-sm font-medium" style={{ color: "var(--text-secondary)" }}>Concepts maîtrisés :</p>
          {step.masteredConcepts.map((c) => (
            <div key={c} className="text-sm px-3 py-1 rounded-lg" style={{ backgroundColor: "rgba(0,255,120,0.1)", color: "var(--success)" }}>✓ {c}</div>
          ))}
        </div>
      )}
      <Button onClick={onNext} className="w-full">Voir les résultats</Button>
    </div>
  );
}
