import { describe, it, expect } from "vitest";
import { calculateSm2 } from "./sm2";

describe("calculateSm2 edge cases", () => {
  it("third repetition uses interval * easeFactor formula", () => {
    const result = calculateSm2({ quality: 4, repetitions: 2, intervalDays: 6, easeFactor: 2.5 });
    expect(result.repetitions).toBe(3);
    expect(result.intervalDays).toBe(Math.max(1, Math.round(6 * result.easeFactor)));
  });

  it("quality 3 is not a lapse", () => {
    const result = calculateSm2({ quality: 3, repetitions: 1, intervalDays: 1, easeFactor: 2.5 });
    expect(result.lapsesDelta).toBe(0);
    expect(result.repetitions).toBe(2);
  });

  it("multiple lapses accumulate correctly", () => {
    const r1 = calculateSm2({ quality: 0, repetitions: 5, intervalDays: 20, easeFactor: 2.5 });
    expect(r1.lapsesDelta).toBe(1);
    expect(r1.repetitions).toBe(0);
  });
});
