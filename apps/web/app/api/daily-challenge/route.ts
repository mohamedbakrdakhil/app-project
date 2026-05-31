import { NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";

export async function GET() {
  try {
    const supabase = await createSupabaseServerClient();

    // Check auth (optional — used only to determine `completed`)
    const {
      data: { user },
    } = await supabase.auth.getUser();

    // Try to fetch today's challenge
    const { data: existing, error: fetchError } = await supabase
      .from("daily_challenges")
      .select(
        `
        challenge_date,
        level_id,
        levels!inner (
          title_fr,
          chapters!inner (
            subject_id
          )
        )
      `,
      )
      .eq("challenge_date", new Date().toISOString().slice(0, 10))
      .maybeSingle();

    if (fetchError) {
      return NextResponse.json({ error: "Database error" }, { status: 500 });
    }

    let challengeDate: string;
    let levelId: string;
    let levelTitle: string;
    let subjectId: string;

    if (existing) {
      challengeDate = existing.challenge_date as string;
      levelId = existing.level_id as string;
      const level = existing.levels as unknown as {
        title_fr: string;
        chapters: { subject_id: string } | Array<{ subject_id: string }>;
      };
      levelTitle = level.title_fr;
      const chapters = level.chapters;
      subjectId = Array.isArray(chapters)
        ? (chapters[0]?.subject_id ?? "")
        : chapters.subject_id;
    } else {
      // No challenge for today — pick a random published level using admin client for INSERT
      const { data: randomLevel, error: randomError } = await supabase
        .from("levels")
        .select(
          `
          id,
          title_fr,
          chapters!inner (
            subject_id
          )
        `,
        )
        .eq("is_published", true)
        .limit(50);

      if (randomError || !randomLevel || randomLevel.length === 0) {
        return NextResponse.json(
          { error: "No levels available" },
          { status: 404 },
        );
      }

      const picked =
        randomLevel[Math.floor(Math.random() * randomLevel.length)]!;
      levelId = picked.id as string;
      levelTitle = picked.title_fr as string;
      const chapters = picked.chapters as
        | { subject_id: string }
        | Array<{ subject_id: string }>;
      subjectId = Array.isArray(chapters)
        ? (chapters[0]?.subject_id ?? "")
        : chapters.subject_id;
      challengeDate = new Date().toISOString().slice(0, 10);

      // Insert using admin client (bypasses RLS since there's no INSERT policy for anon)
      const admin = createSupabaseAdminClient();
      await admin
        .from("daily_challenges")
        .upsert({ challenge_date: challengeDate, level_id: levelId }, { onConflict: "challenge_date", ignoreDuplicates: true });
    }

    // Check if the authenticated user has already completed today's challenge
    let completed = false;
    if (user) {
      const { data: completion } = await supabase
        .from("daily_challenge_completions")
        .select("id")
        .eq("user_id", user.id)
        .eq("challenge_date", challengeDate)
        .maybeSingle();
      completed = completion !== null;
    }

    return NextResponse.json({
      challengeDate,
      levelId,
      levelTitle,
      subjectId,
      completed,
    });
  } catch {
    return NextResponse.json({ error: "Internal error" }, { status: 500 });
  }
}
