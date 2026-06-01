import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export const dynamic = "force-dynamic";

const REASON_VALUES = ["incorrect_content", "typo", "unclear", "outdated", "other"] as const;

const ContentReportBodySchema = z.object({
  levelId: z.string().uuid(),
  questionKey: z.string().optional(),
  reason: z.enum(REASON_VALUES),
  details: z.string().optional(),
});

export async function POST(request: NextRequest) {
  try {
    const supabase = await createSupabaseServerClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    const body = ContentReportBodySchema.parse(await request.json());

    const { data, error } = await supabase
      .from("content_reports")
      .insert({
        reporter_id: user.id,
        level_id: body.levelId,
        question_key: body.questionKey ?? null,
        reason: body.reason,
        details: body.details ?? null,
      })
      .select("id")
      .single();

    if (error) return NextResponse.json({ error: "Internal error" }, { status: 500 });

    return NextResponse.json({ ok: true, reportId: data!.id });
  } catch (e) {
    if (e instanceof z.ZodError) return NextResponse.json({ error: "Invalid input" }, { status: 400 });
    return NextResponse.json({ error: "Internal error" }, { status: 500 });
  }
}

export async function GET() {
  const supabase = await createSupabaseServerClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { data: reports, error } = await supabase
    .from("content_reports")
    .select("id, level_id, question_key, reason, details, status, created_at")
    .eq("reporter_id", user.id)
    .order("created_at", { ascending: false });

  if (error) return NextResponse.json({ error: "Internal error" }, { status: 500 });

  return NextResponse.json({ reports: reports ?? [] });
}
