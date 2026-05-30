import { NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";

export async function GET() {
  const supabase = await createSupabaseServerClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const admin = createSupabaseAdminClient();

  const { data } = await admin
    .from("question_attempts")
    .select("question_key, level_id, is_correct")
    .eq("user_id", user.id)
    .order("answered_at", { ascending: false })
    .limit(500);

  if (!data) return NextResponse.json({ errors: [] });

  const stats: Record<string, { questionKey: string; total: number; wrong: number }> = {};
  for (const row of data) {
    const key = row.question_key as string;
    if (!stats[key]) stats[key] = { questionKey: key, total: 0, wrong: 0 };
    stats[key]!.total += 1;
    if (!row.is_correct) stats[key]!.wrong += 1;
  }

  const errors = Object.values(stats)
    .filter((s) => s.wrong > 0)
    .sort((a, b) => b.wrong - a.wrong)
    .slice(0, 20)
    .map((s) => ({
      questionKey: s.questionKey,
      totalAttempts: s.total,
      wrongAttempts: s.wrong,
      errorRate: Math.round((s.wrong / s.total) * 100),
    }));

  return NextResponse.json({ errors });
}
