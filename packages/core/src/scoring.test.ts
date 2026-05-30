import { describe, it, expect } from "vitest";
import { calculateLessonScore } from "./scoring";

describe("calculateLessonScore", () => {
  it("perfect score → 100%, completed, perfect, full XP", () => {
    const result = calculateLessonScore({ correctCount: 2, totalRecallCount: 2 });
    expect(result.scorePercent).toBe(100);
    expect(result.isCompleted).toBe(true);
    expect(result.isPerfect).toBe(true);
    expect(result.totalXp).toBe(2 * 15 + 30 + 20); // 80
  });

  it("60% → completed", () => {
    const result = calculateLessonScore({ correctCount: 3, totalRecallCount: 5 });
    expect(result.scorePercent).toBe(60);
    expect(result.isCompleted).toBe(true);
    expect(result.isPerfect).toBe(false);
  });

  it("50% → not completed", () => {
    const result = calculateLessonScore({ correctCount: 1, totalRecallCount: 2 });
    expect(result.scorePercent).toBe(50);
    expect(result.isCompleted).toBe(false);
  });
});
