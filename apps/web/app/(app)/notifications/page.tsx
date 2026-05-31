import { redirect } from "next/navigation";
import { getSessionUser } from "@/lib/auth";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";
import NotificationList from "./NotificationList";

export const dynamic = "force-dynamic";
export const metadata = { title: "Notifications" };

export default async function NotificationsPage() {
  const user = await getSessionUser();
  if (!user) redirect("/login");

  const admin = createSupabaseAdminClient();
  const { data: notifications } = await admin
    .from("notifications")
    .select("id, type, title, body, is_read, created_at")
    .eq("user_id", user.id)
    .order("created_at", { ascending: false })
    .limit(30);

  return (
    <div className="space-y-4">
      <h1 className="text-xl font-bold" style={{ color: "var(--text-primary)" }}>Notifications</h1>
      <NotificationList notifications={notifications ?? []} />
    </div>
  );
}
