import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema } from "./lesson-schema";

describe("Biochemistry lesson structure", () => {
  it("validates a lesson with image_label and recall steps", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Les protéines",
          body: "Les protéines sont des macromolécules.",
          sourceRefs: [],
        },
        {
          type: "image_label" as const,
          title: "Structure",
          imageAlt: "Structure des protéines",
          labels: [
            { id: "p", text: "Primaire", position: { x: 20, y: 50 } },
            { id: "s", text: "Secondaire", position: { x: 50, y: 50 } },
          ],
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "protein_001",
          question: "Qu'est-ce que l'hémoglobine ?",
          options: ["Une protéine quaternaire", "Un acide aminé", "Un lipide", "Un glucide"] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "complete" as const,
          title: "Terminé",
          body: "Bravo",
          masteredConcepts: ["biochemistry.proteins.structure"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("rejects lesson with estimatedMinutes = 0", () => {
    expect(() => LessonContentPublicSchema.parse({
      schemaVersion: 1, locale: "fr", estimatedMinutes: 0,
      steps: [{ type: "complete", title: "T", body: "B", masteredConcepts: [] }],
    })).toThrow();
  });
});
