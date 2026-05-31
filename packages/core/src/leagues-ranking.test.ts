import { describe, it, expect } from "vitest";
import { rankLeagueEntries, getWeekStart } from "./leagues";

describe("league ranking edge cases", () => {
  it("handles empty entries list", () => {
    const ranked = rankLeagueEntries([]);
    expect(ranked).toHaveLength(0);
  });

  it("handles single entry", () => {
    const ranked = rankLeagueEntries([{ userId: "a", displayName: "Alice", xpThisWeek: 100, tier: "bronze" as const }]);
    expect(ranked[0]!.rank).toBe(1);
  });

  it("handles tie — preserves order of equal XP", () => {
    const entries = [
      { userId: "a", displayName: "Alice", xpThisWeek: 100, tier: "bronze" as const },
      { userId: "b", displayName: "Bob", xpThisWeek: 100, tier: "bronze" as const },
    ];
    const ranked = rankLeagueEntries(entries);
    expect(ranked).toHaveLength(2);
    expect(ranked[0]!.xpThisWeek).toBe(100);
    expect(ranked[1]!.xpThisWeek).toBe(100);
  });

  it("getWeekStart is always a Monday (day index 1)", () => {
    const dates = ["2026-01-01", "2026-03-15", "2026-06-07", "2026-12-25"];
    for (const d of dates) {
      const ws = getWeekStart(new Date(d));
      const day = new Date(ws).getUTCDay();
      expect(day).toBe(1);
    }
  });
});
