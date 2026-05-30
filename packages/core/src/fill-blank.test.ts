import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, FillBlankStepSchema } from "./lesson-schema";

describe("FillBlankStep schema", () => {
  it("accepts valid fill_blank step", () => {
    const step = {
      type: "fill_blank" as const,
      questionKey: "test_001",
      prompt: "Le fémur est l'os de la ___",
      xpReward: 10,
    };
    expect(() => FillBlankStepSchema.parse(step)).not.toThrow();
  });

  it("accepts lesson with fill_blank step", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 3,
      disclaimer: "Contenu éducatif.",
      steps: [
        {
          type: "fill_blank" as const,
          questionKey: "q1",
          prompt: "Le ___ est l'os de la cuisse",
          xpReward: 10,
        },
        { type: "complete" as const, title: "Terminé", body: "Bravo", masteredConcepts: [] },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("rejects fill_blank step with empty questionKey", () => {
    expect(() =>
      FillBlankStepSchema.parse({
        type: "fill_blank",
        questionKey: "",
        prompt: "Some ___",
      })
    ).toThrow();
  });

  it("rejects fill_blank step with empty prompt", () => {
    expect(() =>
      FillBlankStepSchema.parse({
        type: "fill_blank",
        questionKey: "q1",
        prompt: "",
      })
    ).toThrow();
  });
});
