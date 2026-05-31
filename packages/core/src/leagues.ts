export const LEAGUE_TIERS = ["bronze", "silver", "gold", "platinum", "diamond", "champion"] as const;
export type LeagueTier = typeof LEAGUE_TIERS[number];

export const TIER_COLORS: Record<LeagueTier, string> = {
  bronze: "#cd7f32",
  silver: "#c0c0c0",
  gold: "#ffd700",
  platinum: "#e5e4e2",
  diamond: "#b9f2ff",
  champion: "#ff4d6d",
};

export const TIER_ICONS: Record<LeagueTier, string> = {
  bronze: "🥉",
  silver: "🥈",
  gold: "🥇",
  platinum: "💎",
  diamond: "🔷",
  champion: "👑",
};

export function getWeekStart(date: Date = new Date()): string {
  const d = new Date(date);
  const day = d.getUTCDay();
  const diff = day === 0 ? -6 : 1 - day;
  d.setUTCDate(d.getUTCDate() + diff);
  return d.toISOString().split("T")[0]!;
}

export type LeagueEntry = {
  userId: string;
  displayName: string;
  xpThisWeek: number;
  tier: LeagueTier;
  rank: number;
};

export function rankLeagueEntries(entries: Omit<LeagueEntry, "rank">[]): LeagueEntry[] {
  return entries
    .slice()
    .sort((a, b) => b.xpThisWeek - a.xpThisWeek)
    .map((e, i) => ({ ...e, rank: i + 1 }));
}

export function computeTierPromotion(
  entries: LeagueEntry[],
  currentTier: LeagueTier,
): LeagueTier {
  const tierIdx = LEAGUE_TIERS.indexOf(currentTier);
  void entries;
  void tierIdx;
  // promotion computed at reset time, placeholder
  return currentTier;
}
