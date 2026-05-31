import { NextResponse } from "next/server";
import { requireUser } from "@/lib/auth";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";

export async function GET() {
  let user;
  try {
    user = await requireUser();
  } catch {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const admin = createSupabaseAdminClient();

  const [profileRes, badgesRes, attemptsRes, progressRes] = await Promise.all([
    admin
      .from("profiles")
      .select("username, daily_goal, current_streak, total_xp")
      .eq("id", user.id)
      .single(),
    admin
      .from("user_badges")
      .select("earned_at, badges(name)")
      .eq("user_id", user.id),
    admin
      .from("lesson_attempts")
      .select("level_id, created_at, score, passed")
      .eq("user_id", user.id)
      .order("created_at", { ascending: false })
      .limit(30),
    admin
      .from("user_progress")
      .select("subject_id, levels_completed, total_xp")
      .eq("user_id", user.id),
  ]);

  const exportData = {
    exportedAt: new Date().toISOString(),
    profile: profileRes.data ?? null,
    badges: badgesRes.data ?? [],
    recentLessonAttempts: attemptsRes.data ?? [],
    subjectProgress: progressRes.data ?? [],
  };

  return new NextResponse(JSON.stringify(exportData), {
    status: 200,
    headers: {
      "Content-Type": "application/json",
      "Content-Disposition": 'attachment; filename="masteri-progress.json"',
    },
  });
}
