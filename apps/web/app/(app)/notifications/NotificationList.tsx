"use client";
import { useState } from "react";
import Card from "@/components/ui/Card";

type Notification = {
  id: string;
  type: string;
  title: string;
  body: string;
  is_read: boolean;
  created_at: string;
};

const TYPE_ICONS: Record<string, string> = {
  badge_earned: "🏅",
  streak_reminder: "🔥",
  review_due: "🔄",
  league_result: "🏆",
  level_unlocked: "🔓",
};

export default function NotificationList({ notifications }: { notifications: Notification[] }) {
  const [items, setItems] = useState(notifications);

  const markAllRead = async () => {
    const unreadIds = items.filter((n) => !n.is_read).map((n) => n.id);
    if (unreadIds.length === 0) return;
    await fetch("/api/notifications/read", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ notificationIds: unreadIds }),
    });
    setItems((prev) => prev.map((n) => ({ ...n, is_read: true })));
  };

  if (items.length === 0) {
    return (
      <div className="text-center py-16 space-y-2">
        <div className="text-4xl">🔔</div>
        <p style={{ color: "var(--text-muted)" }}>Aucune notification</p>
      </div>
    );
  }

  const hasUnread = items.some((n) => !n.is_read);

  return (
    <div className="space-y-3">
      {hasUnread && (
        <button
          onClick={markAllRead}
          className="text-sm"
          style={{ color: "var(--anatomy)" }}
        >
          Tout marquer comme lu
        </button>
      )}
      {items.map((n) => (
        <Card
          key={n.id}
          className="flex gap-3"
          style={{ opacity: n.is_read ? 0.6 : 1, border: n.is_read ? "1px solid var(--border-soft)" : "1px solid rgba(255,77,109,0.3)" }}
        >
          <span className="text-2xl flex-shrink-0">{TYPE_ICONS[n.type] ?? "🔔"}</span>
          <div className="flex-1 min-w-0">
            <p className="font-semibold text-sm" style={{ color: "var(--text-primary)" }}>{n.title}</p>
            <p className="text-xs mt-0.5" style={{ color: "var(--text-muted)" }}>{n.body}</p>
            <p className="text-xs mt-1" style={{ color: "var(--text-muted)" }}>
              {new Date(n.created_at).toLocaleDateString("fr-FR", { day: "numeric", month: "short", hour: "2-digit", minute: "2-digit" })}
            </p>
          </div>
          {!n.is_read && (
            <div className="w-2 h-2 rounded-full flex-shrink-0 mt-1" style={{ backgroundColor: "var(--anatomy)" }} />
          )}
        </Card>
      ))}
    </div>
  );
}
