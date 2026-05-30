import type { IntroStep } from "@masteri/core";
import Button from "@/components/ui/Button";
import BoneSVG from "@/components/ui/BoneSVG";

type BoneType = "femur" | "tibia" | "crane" | "fibula" | "vertebra" | "cotes";
const VALID_BONE_TYPES = new Set<BoneType>(["femur", "tibia", "crane", "fibula", "vertebra", "cotes"]);

interface IntroStepProps {
  step: IntroStep;
  onNext: () => void;
  boneType?: string;
}

export default function IntroStepView({ step, onNext, boneType }: IntroStepProps) {
  const resolvedBone = boneType && VALID_BONE_TYPES.has(boneType as BoneType) ? (boneType as BoneType) : undefined;
  return (
    <div className="space-y-6">
      <div className="space-y-2">
        <h1 className="text-2xl font-bold" style={{ color: "var(--text-primary)" }}>{step.title}</h1>
        {step.subtitle && <p className="text-sm font-medium" style={{ color: "var(--anatomy)" }}>{step.subtitle}</p>}
      </div>
      {step.visual?.type === "placeholder" && (
        <div className="h-48 rounded-2xl flex flex-col items-center justify-center" style={{ backgroundColor: "var(--bg-card)", border: "1px solid var(--border-soft)" }}>
          {resolvedBone ? (
            <BoneSVG bone={resolvedBone} className="h-36 w-auto" />
          ) : (
            <span className="text-5xl">🦴</span>
          )}
          {step.visual.caption && <p className="text-xs mt-2" style={{ color: "var(--text-muted)" }}>{step.visual.caption}</p>}
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
