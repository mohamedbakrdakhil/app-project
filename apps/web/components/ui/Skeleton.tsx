interface SkeletonProps {
  className?: string;
  style?: React.CSSProperties;
}

export function Skeleton({ className = "", style }: SkeletonProps) {
  return (
    <div
      className={`rounded-xl skeleton-shimmer ${className}`}
      style={{ minHeight: "1rem", ...style }}
    />
  );
}

export function SkeletonCard() {
  return (
    <div className="rounded-2xl p-4 space-y-3" style={{ backgroundColor: "var(--bg-card)", border: "1px solid var(--border-soft)" }}>
      <Skeleton className="h-4 w-3/4" />
      <Skeleton className="h-3 w-1/2" />
    </div>
  );
}

export function SkeletonSubjectCard() {
  return (
    <div className="rounded-2xl p-4 space-y-2" style={{ backgroundColor: "var(--bg-card)", border: "1px solid var(--border-soft)" }}>
      <div className="flex items-center gap-3">
        <Skeleton className="h-8 w-8 rounded-full" />
        <Skeleton className="h-4 w-24" />
      </div>
      <Skeleton className="h-3 w-full" />
    </div>
  );
}
