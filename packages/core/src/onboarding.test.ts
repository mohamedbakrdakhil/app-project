import { describe, it, expect } from "vitest";
import { z } from "zod";

const OnboardingBodySchema = z.object({
  dailyGoal: z.number().int().min(1).max(50).default(5),
  preferredSubjects: z.array(z.string()).max(6).default([]),
});

describe("Onboarding validation", () => {
  it("accepts valid onboarding payload", () => {
    const result = OnboardingBodySchema.parse({ dailyGoal: 5, preferredSubjects: ["anatomy", "physiology"] });
    expect(result.dailyGoal).toBe(5);
    expect(result.preferredSubjects).toEqual(["anatomy", "physiology"]);
  });

  it("applies default dailyGoal", () => {
    const result = OnboardingBodySchema.parse({ preferredSubjects: [] });
    expect(result.dailyGoal).toBe(5);
  });

  it("rejects dailyGoal over 50", () => {
    expect(() => OnboardingBodySchema.parse({ dailyGoal: 51 })).toThrow();
  });

  it("rejects more than 6 preferred subjects", () => {
    expect(() => OnboardingBodySchema.parse({
      dailyGoal: 3,
      preferredSubjects: ["a", "b", "c", "d", "e", "f", "g"],
    })).toThrow();
  });
});
