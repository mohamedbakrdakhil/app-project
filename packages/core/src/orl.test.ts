import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("ORL lesson validation", () => {
  it("validates ear lesson schema (malleus recall)", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 4,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Anatomie de l'oreille",
          body: "L'oreille comprend trois parties. Oreille externe : pavillon, conduit auditif, tympan. Oreille moyenne : osselets (malleus, incus, stapes) et trompe d'Eustache. Oreille interne : cochlée (audition), canaux semi-circulaires (équilibre).",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "orl_ear_malleus_001",
          question: "Osselet transmettant les vibrations du tympan en premier ?",
          options: [
            "Le marteau (malleus)",
            "L'enclume (incus)",
            "L'étrier (stapes)",
            "La cochlée",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "complete" as const,
          title: "Oreille terminée",
          body: "Tu connais maintenant l'anatomie de l'oreille.",
          masteredConcepts: ["orl.ear.ossicles"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates nose fill_blank answer key (sinus)", () => {
    const key = {
      orl_nose_sinusite_001: {
        acceptedAnswers: ["sinus"],
        explanation:
          "La sinusite est une inflammation des sinus paranasaux, le plus souvent d'origine infectieuse.",
        conceptKey: "orl.nose.sinusitis",
        sourceRefs: [],
      },
      orl_nose_epistaxis_001: {
        correctIndex: 1,
        explanation:
          "Le plexus de Kiesselbach est situé sur le septum antérieur et est le siège de 90% des épistaxis.",
        conceptKey: "orl.nose.kiesselbach",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates epiglottitis clinical_case step schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Gorge et larynx",
          body: "Angine virale ou bactérienne. Épiglottite : urgence avec fièvre, voix étouffée, hypersalivation, position en trépied.",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "orl_throat_epiglottitis_001",
          scenario:
            "Un enfant de 4 ans est amené aux urgences avec fièvre à 40°C, douleur pharyngée intense, voix étouffée, hypersalivation et position en trépied. L'examen est difficile car l'enfant refuse d'ouvrir la bouche.",
          question: "Quel diagnostic faut-il évoquer en urgence ?",
          options: [
            "Angine à streptocoque",
            "Laryngite sous-glottique",
            "Épiglottite aiguë",
            "Abcès périamygdalien",
          ] as [string, string, string, string],
          difficulty: "hard" as const,
          xpReward: 25,
        },
        {
          type: "complete" as const,
          title: "Gorge et larynx terminés",
          body: "Tu connais maintenant les pathologies ORL urgentes.",
          masteredConcepts: ["orl.throat.epiglottitis"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });
});
