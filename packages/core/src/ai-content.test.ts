import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("AI content schema validation", () => {
  it("validates a typical AI-generated lesson structure", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 4,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Le muscle biceps",
          subtitle: "Muscle du bras",
          body: "Le muscle biceps brachial est situé à la face antérieure du bras.",
          fact: "Il possède deux chefs d'origine.",
          visual: { type: "placeholder" as const, alt: "muscle" },
          sourceRefs: [{ title: "Open educational references", type: "open_educational" as const }],
        },
        {
          type: "recall" as const,
          questionKey: "biceps_001",
          question: "Où est situé le muscle biceps brachial ?",
          options: ["Face antérieure du bras", "Face postérieure du bras", "Face antérieure de l'avant-bras", "Face postérieure de l'avant-bras"] as [string, string, string, string],
          timerSeconds: 45,
          xpReward: 15,
        },
        {
          type: "complete" as const,
          title: "Biceps terminé",
          body: "Tu maîtrises les bases du biceps.",
          masteredConcepts: ["anatomy.muscles.biceps"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates a typical AI-generated answer key", () => {
    const key = {
      biceps_001: {
        correctIndex: 0,
        explanation: "Le biceps brachial est un muscle de la loge antérieure du bras.",
        conceptKey: "anatomy.muscles.biceps",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("rejects answer key with invalid correctIndex", () => {
    const key = {
      q_001: { correctIndex: 5, explanation: "test", conceptKey: "test", sourceRefs: [] },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).toThrow();
  });
});
