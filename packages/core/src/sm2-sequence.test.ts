import { describe, it, expect } from "vitest";
import { calculateSm2 } from "./sm2";

describe("SM-2 full learning sequence", () => {
  it("correctly progresses through 4 successful reviews", () => {
    let state = { repetitions: 0, intervalDays: 1, easeFactor: 2.5 };

    // Review 1: quality 4
    const r1 = calculateSm2({ quality: 4, ...state });
    expect(r1.repetitions).toBe(1);
    expect(r1.intervalDays).toBe(1);
    state = { repetitions: r1.repetitions, intervalDays: r1.intervalDays, easeFactor: r1.easeFactor };

    // Review 2: quality 4
    const r2 = calculateSm2({ quality: 4, ...state });
    expect(r2.repetitions).toBe(2);
    expect(r2.intervalDays).toBe(6);
    state = { repetitions: r2.repetitions, intervalDays: r2.intervalDays, easeFactor: r2.easeFactor };

    // Review 3: quality 4 — should use interval * easeFactor
    const r3 = calculateSm2({ quality: 4, ...state });
    expect(r3.repetitions).toBe(3);
    expect(r3.intervalDays).toBeGreaterThan(6);
    state = { repetitions: r3.repetitions, intervalDays: r3.intervalDays, easeFactor: r3.easeFactor };

    // Review 4: quality 4 — interval grows further
    const r4 = calculateSm2({ quality: 4, ...state });
    expect(r4.repetitions).toBe(4);
    expect(r4.intervalDays).toBeGreaterThan(r3.intervalDays);
  });

  it("resets correctly after a lapse mid-sequence", () => {
    // Get to rep=2
    let state = { repetitions: 0, intervalDays: 1, easeFactor: 2.5 };
    const r1 = calculateSm2({ quality: 5, ...state });
    state = { repetitions: r1.repetitions, intervalDays: r1.intervalDays, easeFactor: r1.easeFactor };
    const r2 = calculateSm2({ quality: 5, ...state });
    state = { repetitions: r2.repetitions, intervalDays: r2.intervalDays, easeFactor: r2.easeFactor };

    // Lapse
    const lapse = calculateSm2({ quality: 1, ...state });
    expect(lapse.repetitions).toBe(0);
    expect(lapse.intervalDays).toBe(1);
    expect(lapse.lapsesDelta).toBe(1);
  });
});
