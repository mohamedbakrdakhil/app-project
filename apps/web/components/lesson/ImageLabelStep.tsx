import type { ImageLabelStep } from "@masteri/core";
import Button from "@/components/ui/Button";

interface Props {
  step: ImageLabelStep;
  onNext: () => void;
}

export default function ImageLabelStepView({ step, onNext }: Props) {
  return (
    <div className="space-y-6">
      <h2 className="text-lg font-semibold" style={{ color: "var(--text-primary)" }}>{step.title}</h2>
      <div className="relative rounded-2xl overflow-hidden" style={{ backgroundColor: "var(--bg-secondary)", border: "1px solid var(--border-soft)", aspectRatio: "4/3" }}>
        {/* Placeholder background */}
        <div className="absolute inset-0 flex items-center justify-center" style={{ opacity: 0.15 }}>
          <span className="text-8xl">🔬</span>
        </div>
        {/* Labels */}
        {step.labels.map((label) => (
          <div
            key={label.id}
            className="absolute flex items-center gap-1"
            style={{ left: `${label.position.x}%`, top: `${label.position.y}%`, transform: "translate(-50%, -50%)" }}
          >
            <div
              className="w-3 h-3 rounded-full border-2 flex-shrink-0"
              style={{ backgroundColor: "var(--anatomy)", borderColor: "white" }}
            />
            <span
              className="text-xs font-semibold px-2 py-0.5 rounded-full whitespace-nowrap"
              style={{ backgroundColor: "rgba(6,8,16,0.85)", color: "white", border: "1px solid rgba(255,255,255,0.2)" }}
            >
              {label.text}
            </span>
          </div>
        ))}
      </div>
      {step.caption && (
        <p className="text-xs text-center" style={{ color: "var(--text-muted)" }}>{step.caption}</p>
      )}
      <div className="space-y-1">
        <p className="text-sm font-medium" style={{ color: "var(--text-secondary)" }}>Zones annotées :</p>
        <div className="flex flex-wrap gap-2">
          {step.labels.map((label) => (
            <span key={label.id} className="text-xs px-2 py-1 rounded-full" style={{ backgroundColor: "rgba(255,77,109,0.1)", color: "var(--anatomy)" }}>
              {label.text}
            </span>
          ))}
        </div>
      </div>
      <Button onClick={onNext} className="w-full">Continuer</Button>
    </div>
  );
}
