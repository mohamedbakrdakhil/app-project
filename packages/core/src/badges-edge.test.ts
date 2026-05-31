import { describe, it, expect } from "vitest";
import { evaluateBadges, type BadgeDef } from "./badges";

describe("evaluateBadges edge cases", () => {
  const badges: BadgeDef[] = [
    { id: "xp_500", condition_type: "total_xp", condition_value: 500 },
    { id: "levels_6", condition_type: "levels_complete_count", condition_value: 6 },
  ];

  it("returns empty array when no badges qualify", () => {
    const result = evaluateBadges(badges, { levelsCompleted: 0, hasPerfectScore: false, streakDays: 0, totalXp: 0 }, []);
    expect(result).toHaveLength(0);
  });

  it("awards multiple badges at once", () => {
    const result = evaluateBadges(badges, { levelsCompleted: 6, hasPerfectScore: false, streakDays: 0, totalXp: 500 }, []);
    expect(result).toContain("xp_500");
    expect(result).toContain("levels_6");
    expect(result).toHaveLength(2);
  });

  it("handles empty badge list", () => {
    const result = evaluateBadges([], { levelsCompleted: 10, hasPerfectScore: true, streakDays: 30, totalXp: 9999 }, []);
    expect(result).toHaveLength(0);
  });
});
