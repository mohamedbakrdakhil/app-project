import { redirect } from "next/navigation";
import { getSessionUser } from "@/lib/auth";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";
import Card from "@/components/ui/Card";
import LogoutButton from "./LogoutButton";

export default async function ProfilePage() {
  const user = await getSessionUser();
  if (!user) redirect("/login");

  const admin = createSupabaseAdminClient();
  const { data: profile } = await admin
    .from("profiles")
    .select("full_name, email, streak, total_xp, current_league_tier")
    .eq("id", user.id)
    .single();

  return (
    <div className="space-y-6">
      <h1 className="text-xl font-bold" style={{ color: "var(--text-primary)" }}>Profil</h1>
      <Card className="space-y-4">
        <div>
          <p className="font-semibold text-lg" style={{ color: "var(--text-primary)" }}>{profile?.full_name ?? "Étudiant"}</p>
          <p className="text-sm" style={{ color: "var(--text-muted)" }}>{profile?.email ?? user.email}</p>
        </div>
        <div className="grid grid-cols-3 gap-4 text-center">
          <div>
            <p className="text-2xl font-bold" style={{ color: "var(--xp-color)" }}>{profile?.total_xp ?? 0}</p>
            <p className="text-xs" style={{ color: "var(--text-muted)" }}>XP total</p>
          </div>
          <div>
            <p className="text-2xl font-bold" style={{ color: "var(--streak-color)" }}>🔥 {profile?.streak ?? 0}</p>
            <p className="text-xs" style={{ color: "var(--text-muted)" }}>Streak</p>
          </div>
          <div>
            <p className="text-2xl font-bold" style={{ color: "var(--text-primary)" }}>{profile?.current_league_tier ?? "bronze"}</p>
            <p className="text-xs" style={{ color: "var(--text-muted)" }}>Ligue</p>
          </div>
        </div>
      </Card>
      <LogoutButton />
    </div>
  );
}
