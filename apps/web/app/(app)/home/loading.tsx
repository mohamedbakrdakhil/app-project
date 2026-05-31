import { SkeletonCard, SkeletonSubjectCard } from "@/components/ui/Skeleton";

export default function HomeLoading() {
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div className="space-y-2">
          <div className="h-6 w-36 rounded-xl animate-pulse" style={{ backgroundColor: "var(--bg-card)" }} />
          <div className="h-3 w-24 rounded-xl animate-pulse" style={{ backgroundColor: "var(--bg-card)" }} />
        </div>
        <div className="h-8 w-16 rounded-full animate-pulse" style={{ backgroundColor: "var(--bg-card)" }} />
      </div>
      <div className="h-8 w-full rounded-xl animate-pulse" style={{ backgroundColor: "var(--bg-card)" }} />
      <SkeletonCard />
      <div className="space-y-3">
        <SkeletonSubjectCard />
        <SkeletonSubjectCard />
      </div>
    </div>
  );
}
