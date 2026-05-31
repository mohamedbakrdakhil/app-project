export const metadata = { title: "Leçon" };

import LessonPlayer from "@/components/lesson/LessonPlayer";
import ErrorBoundary from "@/components/ui/ErrorBoundary";
import { getSessionUser } from "@/lib/auth";
import { redirect } from "next/navigation";

interface Props {
  params: Promise<{ levelId: string }>;
}

export default async function LessonPage({ params }: Props) {
  const user = await getSessionUser();
  if (!user) redirect("/login");
  const { levelId } = await params;
  return (
    <div className="min-h-screen p-4 max-w-lg mx-auto" style={{ backgroundColor: "var(--bg-primary)" }}>
      <div className="mb-4">
        <a href="/home" className="text-sm" style={{ color: "var(--text-muted)" }}>← Retour</a>
      </div>
      <ErrorBoundary>
        <LessonPlayer levelId={levelId} />
      </ErrorBoundary>
    </div>
  );
}
