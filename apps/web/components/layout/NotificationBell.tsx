"use client";
import { useState, useEffect } from "react";
import Link from "next/link";

export default function NotificationBell() {
  const [unread, setUnread] = useState(0);

  useEffect(() => {
    fetch("/api/notifications")
      .then((r) => r.json())
      .then((d: { unreadCount?: number }) => setUnread(d.unreadCount ?? 0))
      .catch(() => {});
  }, []);

  return (
    <Link href="/notifications" className="relative p-2">
      <span className="text-xl">🔔</span>
      {unread > 0 && (
        <span
          className="absolute -top-0.5 -right-0.5 w-5 h-5 flex items-center justify-center rounded-full text-xs font-bold text-white"
          style={{ backgroundColor: "var(--anatomy)" }}
        >
          {unread > 9 ? "9+" : unread}
        </span>
      )}
    </Link>
  );
}
