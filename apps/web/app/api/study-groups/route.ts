import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export const dynamic = "force-dynamic";

const CreateGroupBodySchema = z.object({
  name: z.string().min(2).max(50),
  description: z.string().optional(),
});

export async function GET() {
  const supabase = await createSupabaseServerClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user)
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { data, error } = await supabase
    .from("study_group_members")
    .select("group_id, joined_at, study_groups(id, name, description, owner_id, invite_code, created_at)")
    .eq("user_id", user.id);

  if (error)
    return NextResponse.json({ error: "Internal error" }, { status: 500 });

  return NextResponse.json({ groups: data ?? [] });
}

export async function POST(request: NextRequest) {
  try {
    const supabase = await createSupabaseServerClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user)
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    const body = CreateGroupBodySchema.parse(await request.json());

    const { data: group, error: groupError } = await supabase
      .from("study_groups")
      .insert({
        name: body.name,
        description: body.description,
        owner_id: user.id,
      })
      .select("id, invite_code")
      .single();

    if (groupError || !group)
      return NextResponse.json({ error: "Internal error" }, { status: 500 });

    const { error: memberError } = await supabase
      .from("study_group_members")
      .insert({
        group_id: group.id,
        user_id: user.id,
      });

    if (memberError)
      return NextResponse.json({ error: "Internal error" }, { status: 500 });

    return NextResponse.json({ groupId: group.id, inviteCode: group.invite_code });
  } catch (e) {
    if (e instanceof z.ZodError)
      return NextResponse.json({ error: "Invalid input" }, { status: 400 });
    return NextResponse.json({ error: "Internal error" }, { status: 500 });
  }
}
