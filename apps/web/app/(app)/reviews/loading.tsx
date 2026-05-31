import { SkeletonCard } from "@/components/ui/Skeleton";

export default function ReviewsLoading() {
  return (
    <div className="space-y-6">
      <div className="h-6 w-24 rounded-xl animate-pulse" style={{ backgroundColor: "var(--bg-card)" }} />
      <SkeletonCard />
      <div className="grid grid-cols-3 gap-2">
        {[1,2,3,4,5,6].map((i) => (
          <div key={i} className="h-10 rounded-xl animate-pulse" style={{ backgroundColor: "var(--bg-card)" }} />
        ))}
      </div>
    </div>
  );
}
