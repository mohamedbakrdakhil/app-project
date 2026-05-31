import { SkeletonCard } from "@/components/ui/Skeleton";
export default function LeagueLoading() {
  return (
    <div className="space-y-6">
      <div className="h-6 w-20 rounded-xl animate-pulse" style={{ backgroundColor: "var(--bg-card)" }} />
      <SkeletonCard />
      {[1, 2, 3, 4, 5].map((i) => <SkeletonCard key={i} />)}
    </div>
  );
}
