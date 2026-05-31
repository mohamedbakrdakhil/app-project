import { NextResponse } from "next/server";
import { requireUser } from "@/lib/auth";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";

export async function POST() {
  try {
    const user = await requireUser();
    const admin = createSupabaseAdminClient();

    const { data: profile } = await admin
      .from("profiles")
      .select("current_streak")
      .eq("id", user.id)
      .single();

    if (!profile) {
      return NextResponse.json({ error: "Profile not found" }, { status: 404 });
    }

    if (profile.current_streak !== 0) {
      return NextResponse.json({ recovered: false, reason: "not_eligible" });
    }

    await admin
      .from("profiles")
      .update({ current_streak: 1 })
      .eq("id", user.id);

    return NextResponse.json({ recovered: true, newStreak: 1 });
  } catch {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }
}
