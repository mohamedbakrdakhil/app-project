import { describe, it, expect } from "vitest";
import { calculateLessonScore } from "./scoring";

describe("calculateLessonScore edge cases", () => {
  it("handles zero recall questions gracefully", () => {
    const result = calculateLessonScore({ correctCount: 0, totalRecallCount: 0 });
    expect(result.scorePercent).toBe(100);
    expect(result.isCompleted).toBe(true);
  });

  it("returns 0 XP for 0% score", () => {
    const result = calculateLessonScore({ correctCount: 0, totalRecallCount: 2 });
    expect(result.totalXp).toBe(0);
    expect(result.isCompleted).toBe(false);
  });

  it("perfect bonus applies at exactly 100%", () => {
    const r100 = calculateLessonScore({ correctCount: 3, totalRecallCount: 3 });
    const r99 = calculateLessonScore({ correctCount: 2, totalRecallCount: 3 });
    expect(r100.totalXp).toBeGreaterThan(r99.totalXp);
    expect(r100.isPerfect).toBe(true);
    expect(r99.isPerfect).toBe(false);
  });
});
