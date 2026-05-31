export const dynamic = "force-dynamic";

import { redirect, notFound } from "next/navigation";
import { getSessionUser } from "@/lib/auth";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";
import LevelNode from "@/components/ui/LevelNode";

interface Props {
  params: Promise<{ subjectId: string }>;
}

export async function generateMetadata({ params }: Props) {
  const { subjectId } = await params;
  return { title: subjectId.charAt(0).toUpperCase() + subjectId.slice(1) };
}

export default async function SubjectPage({ params }: Props) {
  const user = await getSessionUser();
  if (!user) redirect("/login");

  const { subjectId } = await params;
  const admin = createSupabaseAdminClient();

  const { data: subject } = await admin
    .from("subjects")
    .select("id, name_fr, icon, color, description_fr")
    .eq("id", subjectId)
    .eq("is_published", true)
    .single();

  if (!subject) notFound();

  const { data: chapters } = await admin
    .from("chapters")
    .select("id, title_fr, icon, order_index")
    .eq("subject_id", subjectId)
    .eq("is_published", true)
    .order("order_index");

  const chapterIds = (chapters ?? []).map((c) => c.id);

  const levelsRes = chapterIds.length
    ? await admin
        .from("levels")
        .select("id, chapter_id, title_fr, order_index")
        .in("chapter_id", chapterIds)
        .eq("is_published", true)
        .order("order_index")
    : { data: [] };

  const levels = levelsRes.data ?? [];

  const { data: progress } = await admin
    .from("user_progress")
    .select("level_id, is_completed")
    .eq("user_id", user.id);

  const completedIds = new Set((progress ?? []).filter((p) => p.is_completed).map((p) => p.level_id));

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <span className="text-4xl">{subject.icon}</span>
        <div>
          <h1 className="text-2xl font-bold" style={{ color: "var(--text-primary)" }}>{subject.name_fr}</h1>
          {subject.description_fr && <p className="text-sm" style={{ color: "var(--text-muted)" }}>{subject.description_fr}</p>}
        </div>
      </div>

      {(chapters ?? []).map((chapter) => {
        const chapterLevels = levels
          .filter((l) => l.chapter_id === chapter.id)
          .sort((a, b) => a.order_index - b.order_index);
        const chapterComplete = chapterLevels.filter((l) => completedIds.has(l.id)).length;
        const chapterTotal = chapterLevels.length;
        const chapterPct = chapterTotal > 0 ? Math.round((chapterComplete / chapterTotal) * 100) : 0;
        return (
          <div key={chapter.id} className="space-y-3">
            <div className="flex items-center gap-2">
              <span>{chapter.icon ?? "📖"}</span>
              <h2 className="font-semibold" style={{ color: "var(--text-secondary)" }}>{chapter.title_fr}</h2>
              <span className="ml-auto text-xs" style={{ color: "var(--text-muted)" }}>{chapterComplete} / {chapterTotal} niveaux complétés</span>
            </div>
            <div className="h-1.5 rounded-full overflow-hidden" style={{ backgroundColor: "var(--bg-card)" }}>
              <div className="h-full rounded-full transition-all" style={{ width: `${chapterPct}%`, backgroundColor: "var(--anatomy)" }} />
            </div>
            <div className="space-y-2">
              {chapterLevels.map((level, idx) => {
                const isCompleted = completedIds.has(level.id);
                const prevLevel = chapterLevels[idx - 1];
                const prevCompleted = idx === 0 || (prevLevel !== undefined && completedIds.has(prevLevel.id));
                const state = isCompleted ? "completed" : prevCompleted ? "available" : "locked";
                return (
                  <LevelNode
                    key={level.id}
                    id={level.id}
                    titleFr={level.title_fr}
                    orderIndex={level.order_index}
                    state={state}
                  />
                );
              })}
            </div>
          </div>
        );
      })}
    </div>
  );
}
