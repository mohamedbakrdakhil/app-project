import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";
import type { LessonContentPublic } from "@masteri/core";

const StartBodySchema = z.object({
  levelId: z.string().uuid(),
});

export async function POST(request: NextRequest) {
  try {
    const supabase = await createSupabaseServerClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    const body = StartBodySchema.parse(await request.json());
    const admin = createSupabaseAdminClient();

    const { data: level, error: levelErr } = await admin
      .from("levels")
      .select("id, title_fr, content_public, is_published")
      .eq("id", body.levelId)
      .eq("is_published", true)
      .single();

    if (levelErr || !level) {
      return NextResponse.json({ error: "Level not found" }, { status: 404 });
    }

    const { data: attempt, error: attemptErr } = await admin
      .from("lesson_attempts")
      .insert({ user_id: user.id, level_id: level.id, status: "started" })
      .select("id")
      .single();

    if (attemptErr || !attempt) {
      return NextResponse.json({ error: "Failed to create attempt" }, { status: 500 });
    }

    return NextResponse.json({
      attemptId: attempt.id,
      level: {
        id: level.id,
        titleFr: level.title_fr,
        contentPublic: level.content_public as LessonContentPublic,
      },
    });
  } catch (e) {
    if (e instanceof z.ZodError) return NextResponse.json({ error: "Invalid input" }, { status: 400 });
    return NextResponse.json({ error: "Internal error" }, { status: 500 });
  }
}
