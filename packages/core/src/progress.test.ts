import { describe, it, expect } from "vitest";
import { computeProgressSummary } from "./progress";

describe("computeProgressSummary", () => {
  it("returns 0% for no completed levels", () => {
    const result = computeProgressSummary(6, []);
    expect(result.percentComplete).toBe(0);
    expect(result.completedLevels).toBe(0);
  });

  it("returns 100% when all completed", () => {
    const result = computeProgressSummary(3, ["a", "b", "c"]);
    expect(result.percentComplete).toBe(100);
  });

  it("returns 50% when half completed", () => {
    const result = computeProgressSummary(6, ["a", "b", "c"]);
    expect(result.percentComplete).toBe(50);
  });

  it("handles zero total levels", () => {
    const result = computeProgressSummary(0, []);
    expect(result.percentComplete).toBe(0);
  });
});
