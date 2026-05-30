import { describe, it, expect } from "vitest";
import { calculateSm2 } from "./sm2";

describe("calculateSm2", () => {
  it("quality 5 first revision → interval 1, repetitions 1", () => {
    const result = calculateSm2({ quality: 5, repetitions: 0, intervalDays: 1, easeFactor: 2.5 });
    expect(result.repetitions).toBe(1);
    expect(result.intervalDays).toBe(1);
    expect(result.lapsesDelta).toBe(0);
  });

  it("quality 5 second revision → interval 6, repetitions 2", () => {
    const result = calculateSm2({ quality: 5, repetitions: 1, intervalDays: 1, easeFactor: 2.5 });
    expect(result.repetitions).toBe(2);
    expect(result.intervalDays).toBe(6);
  });

  it("quality 2 → reset repetitions 0, interval 1, lapses +1", () => {
    const result = calculateSm2({ quality: 2, repetitions: 3, intervalDays: 10, easeFactor: 2.5 });
    expect(result.repetitions).toBe(0);
    expect(result.intervalDays).toBe(1);
    expect(result.lapsesDelta).toBe(1);
  });

  it("ease factor never below 1.3", () => {
    const result = calculateSm2({ quality: 0, repetitions: 0, intervalDays: 1, easeFactor: 1.3 });
    expect(result.easeFactor).toBeGreaterThanOrEqual(1.3);
  });
});
