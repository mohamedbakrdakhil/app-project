import { describe, it, expect } from "vitest";
import { calculateLessonScore, XP_RULES } from "./scoring";

describe("scoring advanced", () => {
  it("correct XP formula: correctCount * correctAnswer + completionBonus + perfectBonus", () => {
    const result = calculateLessonScore({ correctCount: 3, totalRecallCount: 3 });
    const expected = 3 * XP_RULES.correctAnswer + XP_RULES.completionBonus + XP_RULES.perfectLessonBonus;
    expect(result.totalXp).toBe(expected);
  });

  it("no completionBonus when score < 60%", () => {
    const result = calculateLessonScore({ correctCount: 1, totalRecallCount: 3 }); // 33%
    expect(result.isCompleted).toBe(false);
    expect(result.totalXp).toBe(1 * XP_RULES.correctAnswer);
  });

  it("completionBonus without perfectBonus at 60%", () => {
    const result = calculateLessonScore({ correctCount: 3, totalRecallCount: 5 }); // 60%
    expect(result.isCompleted).toBe(true);
    expect(result.isPerfect).toBe(false);
    expect(result.totalXp).toBe(3 * XP_RULES.correctAnswer + XP_RULES.completionBonus);
  });
});
