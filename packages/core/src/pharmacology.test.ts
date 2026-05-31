import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Pharmacology lesson validation", () => {
  it("validates pharmacokinetics lesson with fill_blank", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        { type: "intro" as const, title: "Absorption", body: "L'absorption est le passage du médicament dans la circulation.", sourceRefs: [] },
        { type: "fill_blank" as const, questionKey: "pk_001", prompt: "La biodisponibilité par voie IV est de ___.", xpReward: 10 },
        { type: "complete" as const, title: "Terminé", body: "Bravo", masteredConcepts: ["pharmacology.pk.absorption"] },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates answer key with fill_blank entry", () => {
    const key = {
      pk_001: {
        acceptedAnswers: ["100%", "100"],
        explanation: "La voie IV bypass toutes les barrières d'absorption.",
        conceptKey: "pharmacology.pk.absorption.iv",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });
});
