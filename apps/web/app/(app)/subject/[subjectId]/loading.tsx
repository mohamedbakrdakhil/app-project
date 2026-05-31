import { SkeletonCard } from "@/components/ui/Skeleton";

export default function SubjectLoading() {
  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <div className="h-12 w-12 rounded-2xl animate-pulse" style={{ backgroundColor: "var(--bg-card)" }} />
        <div className="space-y-2">
          <div className="h-6 w-32 rounded-xl animate-pulse" style={{ backgroundColor: "var(--bg-card)" }} />
          <div className="h-3 w-48 rounded-xl animate-pulse" style={{ backgroundColor: "var(--bg-card)" }} />
        </div>
      </div>
      <div className="space-y-2">
        {[1,2,3].map((i) => <SkeletonCard key={i} />)}
      </div>
    </div>
  );
}
