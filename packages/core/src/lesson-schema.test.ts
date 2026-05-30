import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema } from "./lesson-schema";

const validLesson = {
  schemaVersion: 1 as const,
  locale: "fr" as const,
  estimatedMinutes: 4,
  disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
  steps: [
    {
      type: "intro" as const,
      title: "Le fémur",
      body: "Le fémur est l'os de la cuisse.",
      sourceRefs: [],
    },
    {
      type: "recall" as const,
      questionKey: "femur_role_001",
      question: "Quel est le rôle du fémur ?",
      options: ["Transmettre le poids", "Protéger le cerveau", "Former le thorax", "Relier la main"] as [string, string, string, string],
      xpReward: 15,
    },
    {
      type: "complete" as const,
      title: "Terminé",
      body: "Tu as complété la leçon.",
      masteredConcepts: [],
    },
  ],
};

describe("LessonContentPublicSchema", () => {
  it("accepts valid lesson", () => {
    expect(() => LessonContentPublicSchema.parse(validLesson)).not.toThrow();
  });

  it("rejects lesson without steps", () => {
    expect(() => LessonContentPublicSchema.parse({ ...validLesson, steps: [] })).toThrow();
  });

  it("rejects wrong schema version", () => {
    expect(() => LessonContentPublicSchema.parse({ ...validLesson, schemaVersion: 2 })).toThrow();
  });
});
