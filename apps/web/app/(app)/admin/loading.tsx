import { SkeletonCard } from "@/components/ui/Skeleton";

export default function AdminLoading() {
  return (
    <div className="space-y-6">
      <div className="h-6 w-32 rounded-xl animate-pulse" style={{ backgroundColor: "var(--bg-card)" }} />
      <SkeletonCard />
      <SkeletonCard />
    </div>
  );
}
