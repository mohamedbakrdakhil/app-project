import { describe, it, expect } from "vitest";
import { getWeekStart, rankLeagueEntries, TIER_COLORS, TIER_ICONS } from "./leagues";

describe("leagues", () => {
  it("getWeekStart returns a Monday", () => {
    const weekStart = getWeekStart(new Date("2026-05-31")); // Saturday
    const day = new Date(weekStart).getUTCDay();
    expect(day).toBe(1); // Monday
  });

  it("rankLeagueEntries sorts by xp descending", () => {
    const entries = [
      { userId: "a", displayName: "Alice", xpThisWeek: 50, tier: "bronze" as const },
      { userId: "b", displayName: "Bob", xpThisWeek: 120, tier: "bronze" as const },
      { userId: "c", displayName: "Carol", xpThisWeek: 80, tier: "bronze" as const },
    ];
    const ranked = rankLeagueEntries(entries);
    expect(ranked[0]!.userId).toBe("b");
    expect(ranked[0]!.rank).toBe(1);
    expect(ranked[1]!.userId).toBe("c");
    expect(ranked[2]!.userId).toBe("a");
  });

  it("TIER_COLORS has all 6 tiers", () => {
    expect(Object.keys(TIER_COLORS)).toHaveLength(6);
  });

  it("TIER_ICONS has all 6 tiers", () => {
    expect(Object.keys(TIER_ICONS)).toHaveLength(6);
  });
});
