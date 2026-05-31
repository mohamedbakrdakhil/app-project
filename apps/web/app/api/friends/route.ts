import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export const dynamic = "force-dynamic";

const FriendRequestBodySchema = z.object({
  receiverId: z.string().uuid(),
});

export async function GET() {
  const supabase = await createSupabaseServerClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user)
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { data: sent, error: sentError } = await supabase
    .from("friend_requests")
    .select("id, receiver_id, status, created_at")
    .eq("sender_id", user.id);

  if (sentError)
    return NextResponse.json({ error: "Internal error" }, { status: 500 });

  const { data: received, error: receivedError } = await supabase
    .from("friend_requests")
    .select("id, sender_id, status, created_at")
    .eq("receiver_id", user.id);

  if (receivedError)
    return NextResponse.json({ error: "Internal error" }, { status: 500 });

  const allAccepted = [
    ...(sent ?? []).filter((r) => r.status === "accepted"),
    ...(received ?? []).filter((r) => r.status === "accepted"),
  ];

  return NextResponse.json({
    sent: sent ?? [],
    received: received ?? [],
    friends: allAccepted,
  });
}

export async function POST(request: NextRequest) {
  try {
    const supabase = await createSupabaseServerClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user)
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    const body = FriendRequestBodySchema.parse(await request.json());

    const { data, error } = await supabase
      .from("friend_requests")
      .insert({
        sender_id: user.id,
        receiver_id: body.receiverId,
      })
      .select("id")
      .single();

    if (error) {
      if (error.code === "23505") {
        return NextResponse.json(
          { error: "Friend request already sent" },
          { status: 409 },
        );
      }
      return NextResponse.json({ error: "Internal error" }, { status: 500 });
    }

    return NextResponse.json({ ok: true, requestId: data!.id });
  } catch (e) {
    if (e instanceof z.ZodError)
      return NextResponse.json({ error: "Invalid input" }, { status: 400 });
    return NextResponse.json({ error: "Internal error" }, { status: 500 });
  }
}
