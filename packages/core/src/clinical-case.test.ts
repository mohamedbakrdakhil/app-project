import { describe, it, expect } from "vitest";
import { ClinicalCaseStepSchema, LessonContentPublicSchema } from "./lesson-schema";

describe("ClinicalCaseStep schema", () => {
  it("accepts valid clinical_case step", () => {
    const step = {
      type: "clinical_case" as const,
      questionKey: "case_001",
      scenario: "Un patient de 50 ans présente une douleur thoracique irradiant dans le bras gauche depuis 30 minutes.",
      question: "Quel est le diagnostic le plus probable ?",
      options: ["Infarctus du myocarde", "Pneumothorax", "Péricardite", "Dissection aortique"] as [string, string, string, string],
      xpReward: 25,
      difficulty: "medium" as const,
    };
    expect(() => ClinicalCaseStepSchema.parse(step)).not.toThrow();
  });

  it("rejects step with scenario shorter than 10 chars", () => {
    expect(() => ClinicalCaseStepSchema.parse({
      type: "clinical_case",
      questionKey: "c001",
      scenario: "Short",
      question: "Q?",
      options: ["A", "B", "C", "D"],
      xpReward: 25,
      difficulty: "easy",
    })).toThrow();
  });

  it("defaults xpReward to 25", () => {
    const result = ClinicalCaseStepSchema.parse({
      type: "clinical_case" as const,
      questionKey: "c001",
      scenario: "Un long scénario clinique de test suffisamment détaillé.",
      question: "Quelle est la réponse ?",
      options: ["A", "B", "C", "D"] as [string, string, string, string],
      difficulty: "easy" as const,
    });
    expect(result.xpReward).toBe(25);
  });

  it("accepts lesson with clinical_case step", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif.",
      steps: [
        {
          type: "clinical_case" as const,
          questionKey: "case_001",
          scenario: "Un patient de 60 ans présente une hématurie macroscopique indolore depuis 2 semaines.",
          question: "Quel est le premier diagnostic à éliminer ?",
          options: ["Tumeur de la vessie", "Lithiase rénale", "Cystite bactérienne", "Prostatite aiguë"] as [string, string, string, string],
          xpReward: 25,
          difficulty: "hard" as const,
        },
        { type: "complete" as const, title: "Terminé", body: "Bravo", masteredConcepts: [] },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });
});
