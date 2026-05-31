import { SkeletonCard } from "@/components/ui/Skeleton";
export default function NotificationsLoading() {
  return (
    <div className="space-y-4">
      <div className="h-6 w-32 rounded-xl animate-pulse" style={{ backgroundColor: "var(--bg-card)" }} />
      {[1, 2, 3, 4, 5].map((i) => <SkeletonCard key={i} />)}
    </div>
  );
}
