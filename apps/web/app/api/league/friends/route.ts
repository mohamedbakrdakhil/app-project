import { NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";
import { getWeekStart } from "@masteri/core";

export const dynamic = "force-dynamic";

export async function GET() {
  const supabase = await createSupabaseServerClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const admin = createSupabaseAdminClient();
  const weekStart = getWeekStart();

  // Get accepted friend_requests where current user is sender or receiver
  const { data: friendRequests } = await admin
    .from("friend_requests")
    .select("sender_id, receiver_id")
    .eq("status", "accepted")
    .or(`sender_id.eq.${user.id},receiver_id.eq.${user.id}`);

  const friendIds = (friendRequests ?? []).map((r) =>
    r.sender_id === user.id ? (r.receiver_id as string) : (r.sender_id as string)
  );

  // Include the current user
  const allUserIds = [...new Set([user.id, ...friendIds])];

  // Get weekly XP for all these users
  const { data: weeklyXpRows } = await admin
    .from("weekly_xp")
    .select("user_id, xp_earned")
    .eq("week_start", weekStart)
    .in("user_id", allUserIds);

  // Get profile names
  const { data: profileRows } = await admin
    .from("profiles")
    .select("id, full_name, email")
    .in("id", allUserIds);

  const nameMap = new Map(
    (profileRows ?? []).map((p) => [
      p.id as string,
      (p.full_name ?? p.email ?? "Étudiant") as string,
    ])
  );

  const xpMap = new Map(
    (weeklyXpRows ?? []).map((r) => [r.user_id as string, r.xp_earned as number])
  );

  // Build list with XP defaulting to 0 for users without entries
  const entries = allUserIds.map((uid) => ({
    userId: uid,
    username: nameMap.get(uid) ?? "Étudiant",
    weeklyXp: xpMap.get(uid) ?? 0,
  }));

  // Sort descending by weeklyXp and assign rank
  entries.sort((a, b) => b.weeklyXp - a.weeklyXp);
  const ranked = entries.map((e, i) => ({ ...e, rank: i + 1 }));

  return NextResponse.json({ friends: ranked });
}
