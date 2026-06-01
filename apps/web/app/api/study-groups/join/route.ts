import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export const dynamic = "force-dynamic";

const JoinGroupBodySchema = z.object({
  inviteCode: z.string().min(1),
});

export async function POST(request: NextRequest) {
  try {
    const supabase = await createSupabaseServerClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user)
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    const body = JoinGroupBodySchema.parse(await request.json());

    const { data: group, error: groupError } = await supabase
      .from("study_groups")
      .select("id")
      .eq("invite_code", body.inviteCode)
      .maybeSingle();

    if (groupError)
      return NextResponse.json({ error: "Internal error" }, { status: 500 });

    if (!group)
      return NextResponse.json({ error: "Invalid invite code" }, { status: 404 });

    const { error: memberError } = await supabase
      .from("study_group_members")
      .insert({
        group_id: group.id,
        user_id: user.id,
      });

    if (memberError) {
      if (memberError.code === "23505")
        return NextResponse.json({ error: "Already a member" }, { status: 409 });
      return NextResponse.json({ error: "Internal error" }, { status: 500 });
    }

    return NextResponse.json({ ok: true, groupId: group.id });
  } catch (e) {
    if (e instanceof z.ZodError)
      return NextResponse.json({ error: "Invalid input" }, { status: 400 });
    return NextResponse.json({ error: "Internal error" }, { status: 500 });
  }
}
