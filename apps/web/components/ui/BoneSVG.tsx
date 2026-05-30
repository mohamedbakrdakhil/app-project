"use client";

type BoneType = "femur" | "tibia" | "crane" | "fibula" | "vertebra" | "cotes";

interface BoneSVGProps {
  bone: BoneType;
  className?: string;
}

export default function BoneSVG({ bone, className = "" }: BoneSVGProps) {
  const svgs: Record<BoneType, React.ReactNode> = {
    femur: (
      <svg viewBox="0 0 100 220" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
        <ellipse cx="30" cy="25" rx="22" ry="18" fill="#ff4d6d" opacity="0.7"/>
        <rect x="40" y="35" width="18" height="140" rx="9" fill="#e8edf5" opacity="0.8"/>
        <ellipse cx="49" cy="185" rx="28" ry="18" fill="#e8edf5" opacity="0.6"/>
        <circle cx="30" cy="25" r="10" fill="#ff4d6d" opacity="0.9"/>
      </svg>
    ),
    tibia: (
      <svg viewBox="0 0 80 240" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
        <ellipse cx="40" cy="30" rx="28" ry="18" fill="#e8edf5" opacity="0.7"/>
        <rect x="32" y="42" width="20" height="155" rx="6" fill="#e8edf5" opacity="0.85"/>
        <ellipse cx="40" cy="205" rx="22" ry="14" fill="#e8edf5" opacity="0.6"/>
      </svg>
    ),
    crane: (
      <svg viewBox="0 0 160 180" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
        <ellipse cx="80" cy="75" rx="68" ry="65" fill="#e8edf5" opacity="0.75"/>
        <rect x="42" y="128" width="76" height="32" rx="4" fill="#e8edf5" opacity="0.6"/>
        <ellipse cx="55" cy="90" rx="12" ry="9" fill="#060810" opacity="0.5"/>
        <ellipse cx="105" cy="90" rx="12" ry="9" fill="#060810" opacity="0.5"/>
        <path d="M65 120 Q80 130 95 120" stroke="#9aa8ba" strokeWidth="2" fill="none"/>
      </svg>
    ),
    fibula: (
      <svg viewBox="0 0 40 240" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
        <ellipse cx="20" cy="20" rx="12" ry="10" fill="#e8edf5" opacity="0.7"/>
        <rect x="16" y="28" width="8" height="180" rx="4" fill="#e8edf5" opacity="0.8"/>
        <ellipse cx="20" cy="215" rx="14" ry="10" fill="#e8edf5" opacity="0.6"/>
      </svg>
    ),
    vertebra: (
      <svg viewBox="0 0 140 100" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
        <rect x="30" y="30" width="80" height="40" rx="8" fill="#e8edf5" opacity="0.75"/>
        <rect x="52" y="10" width="36" height="20" rx="4" fill="#9aa8ba" opacity="0.7"/>
        <rect x="52" y="70" width="36" height="20" rx="4" fill="#9aa8ba" opacity="0.7"/>
        <rect x="5" y="35" width="28" height="12" rx="4" fill="#9aa8ba" opacity="0.6"/>
        <rect x="107" y="35" width="28" height="12" rx="4" fill="#9aa8ba" opacity="0.6"/>
        <ellipse cx="70" cy="50" rx="14" ry="14" fill="#060810" opacity="0.4"/>
      </svg>
    ),
    cotes: (
      <svg viewBox="0 0 160 200" fill="none" xmlns="http://www.w3.org/2000/svg" className={className}>
        {[0,1,2,3,4,5].map((i) => (
          <path
            key={i}
            d={`M 20 ${30 + i * 28} Q 80 ${10 + i * 28} 140 ${35 + i * 28}`}
            stroke="#e8edf5"
            strokeWidth="7"
            strokeLinecap="round"
            fill="none"
            opacity={0.5 + i * 0.05}
          />
        ))}
        <rect x="72" y="20" width="16" height="140" rx="6" fill="#9aa8ba" opacity="0.6"/>
      </svg>
    ),
  };
  return <>{svgs[bone]}</>;
}
