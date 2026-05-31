import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export const dynamic = "force-dynamic";

const ReferralBodySchema = z.object({
  email: z.string().email(),
});

export async function GET() {
  const supabase = await createSupabaseServerClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user)
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { data: referrals, error } = await supabase
    .from("referrals")
    .select("id, referred_email, status, created_at")
    .eq("referrer_id", user.id)
    .order("created_at", { ascending: false });

  if (error)
    return NextResponse.json({ error: "Internal error" }, { status: 500 });

  const list = referrals ?? [];
  const total = list.length;
  const completed = list.filter((r) => r.status === "completed").length;
  const pending = list.filter((r) => r.status === "pending").length;

  return NextResponse.json({ referrals: list, total, completed, pending });
}

export async function POST(request: NextRequest) {
  try {
    const supabase = await createSupabaseServerClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user)
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    const body = ReferralBodySchema.parse(await request.json());

    const { data, error } = await supabase
      .from("referrals")
      .insert({
        referrer_id: user.id,
        referred_email: body.email,
      })
      .select("id")
      .single();

    if (error) {
      if (error.code === "23505") {
        return NextResponse.json(
          { error: "Already referred" },
          { status: 409 }
        );
      }
      return NextResponse.json({ error: "Internal error" }, { status: 500 });
    }

    return NextResponse.json({ ok: true, referralId: data!.id });
  } catch (e) {
    if (e instanceof z.ZodError)
      return NextResponse.json({ error: "Invalid input" }, { status: 400 });
    return NextResponse.json({ error: "Internal error" }, { status: 500 });
  }
}
