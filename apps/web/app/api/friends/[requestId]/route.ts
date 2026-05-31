import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export const dynamic = "force-dynamic";

const ActionBodySchema = z.object({
  action: z.enum(["accept", "decline"]),
});

export async function PATCH(
  request: NextRequest,
  { params }: { params: Promise<{ requestId: string }> },
) {
  try {
    const { requestId } = await params;

    const supabase = await createSupabaseServerClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user)
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    const body = ActionBodySchema.parse(await request.json());
    const newStatus = body.action === "accept" ? "accepted" : "declined";

    const { data: existing, error: fetchError } = await supabase
      .from("friend_requests")
      .select("id, receiver_id")
      .eq("id", requestId)
      .single();

    if (fetchError || !existing)
      return NextResponse.json(
        { error: "Friend request not found" },
        { status: 404 },
      );

    if (existing.receiver_id !== user.id)
      return NextResponse.json({ error: "Forbidden" }, { status: 403 });

    const { error: updateError } = await supabase
      .from("friend_requests")
      .update({ status: newStatus })
      .eq("id", requestId);

    if (updateError)
      return NextResponse.json({ error: "Internal error" }, { status: 500 });

    return NextResponse.json({ ok: true });
  } catch (e) {
    if (e instanceof z.ZodError)
      return NextResponse.json({ error: "Invalid input" }, { status: 400 });
    return NextResponse.json({ error: "Internal error" }, { status: 500 });
  }
}
