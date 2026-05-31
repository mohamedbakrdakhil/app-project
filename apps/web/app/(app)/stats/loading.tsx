import { SkeletonCard } from "@/components/ui/Skeleton";
export default function StatsLoading() {
  return (
    <div className="space-y-6">
      <div className="h-6 w-32 rounded-xl animate-pulse" style={{ backgroundColor: "var(--bg-card)" }} />
      <div className="grid grid-cols-2 gap-3">
        {[1, 2, 3, 4, 5, 6].map((i) => <SkeletonCard key={i} />)}
      </div>
      <SkeletonCard />
      <SkeletonCard />
    </div>
  );
}
