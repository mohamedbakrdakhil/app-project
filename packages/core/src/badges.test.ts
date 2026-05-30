import { describe, it, expect } from "vitest";
import { evaluateBadges } from "./badges";

const badges = [
  { id: "first_steps", condition_type: "first_level_complete" as const, condition_value: 1 },
  { id: "perfectionist", condition_type: "perfect_score" as const, condition_value: 1 },
  { id: "streak_3", condition_type: "streak_days" as const, condition_value: 3 },
  { id: "xp_100", condition_type: "total_xp" as const, condition_value: 100 },
  { id: "levels_3", condition_type: "levels_complete_count" as const, condition_value: 3 },
];

describe("evaluateBadges", () => {
  it("awards first_steps on first completion", () => {
    const result = evaluateBadges(badges, { levelsCompleted: 1, hasPerfectScore: false, streakDays: 1, totalXp: 50 }, []);
    expect(result).toContain("first_steps");
  });

  it("awards perfectionist on perfect score", () => {
    const result = evaluateBadges(badges, { levelsCompleted: 1, hasPerfectScore: true, streakDays: 1, totalXp: 80 }, []);
    expect(result).toContain("perfectionist");
  });

  it("does not re-award already earned badge", () => {
    const result = evaluateBadges(badges, { levelsCompleted: 5, hasPerfectScore: true, streakDays: 7, totalXp: 500 }, ["first_steps", "perfectionist"]);
    expect(result).not.toContain("first_steps");
    expect(result).not.toContain("perfectionist");
  });

  it("awards xp_100 when threshold met", () => {
    const result = evaluateBadges(badges, { levelsCompleted: 0, hasPerfectScore: false, streakDays: 0, totalXp: 100 }, []);
    expect(result).toContain("xp_100");
  });

  it("does not award streak badge below threshold", () => {
    const result = evaluateBadges(badges, { levelsCompleted: 0, hasPerfectScore: false, streakDays: 2, totalXp: 0 }, []);
    expect(result).not.toContain("streak_3");
  });
});
