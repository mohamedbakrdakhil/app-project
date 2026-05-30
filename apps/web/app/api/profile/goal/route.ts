import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";

const GoalBodySchema = z.object({
  dailyGoal: z.number().int().min(1).max(50),
});

export async function PUT(request: NextRequest) {
  const supabase = await createSupabaseServerClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  try {
    const body = GoalBodySchema.parse(await request.json());
    const admin = createSupabaseAdminClient();
    await admin.from("profiles").update({ daily_goal: body.dailyGoal }).eq("id", user.id);
    return NextResponse.json({ dailyGoal: body.dailyGoal });
  } catch (e) {
    if (e instanceof z.ZodError) return NextResponse.json({ error: "Invalid input" }, { status: 400 });
    return NextResponse.json({ error: "Internal error" }, { status: 500 });
  }
}
