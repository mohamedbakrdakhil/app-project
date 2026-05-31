import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";

const OnboardingBodySchema = z.object({
  dailyGoal: z.number().int().min(1).max(50).default(5),
  preferredSubjects: z.array(z.string()).max(6).default([]),
});

export async function POST(request: NextRequest) {
  const supabase = await createSupabaseServerClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  try {
    const body = OnboardingBodySchema.parse(await request.json());
    const admin = createSupabaseAdminClient();
    await admin.from("profiles").update({
      onboarding_completed: true,
      daily_goal: body.dailyGoal,
      preferred_subjects: body.preferredSubjects,
    }).eq("id", user.id);
    return NextResponse.json({ ok: true });
  } catch (e) {
    if (e instanceof z.ZodError) return NextResponse.json({ error: "Invalid input" }, { status: 400 });
    return NextResponse.json({ error: "Internal error" }, { status: 500 });
  }
}
