import { SkeletonCard } from "@/components/ui/Skeleton";

export default function ProfileLoading() {
  return (
    <div className="space-y-6">
      <div className="h-6 w-20 rounded-xl animate-pulse" style={{ backgroundColor: "var(--bg-card)" }} />
      <SkeletonCard />
      <SkeletonCard />
      <SkeletonCard />
    </div>
  );
}
