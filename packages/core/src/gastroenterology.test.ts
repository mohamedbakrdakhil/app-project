import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Gastroenterology lesson validation", () => {
  it("validates ulcer H. pylori recall schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Ulcère peptique",
          body: "L'ulcère peptique peut être gastrique ou duodénal. H. pylori est la cause principale (90% des ulcères duodénaux).",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "gastro_ulcer_cause_001",
          question: "Principale cause d'ulcère duodénal ?",
          options: [
            "Les AINS (anti-inflammatoires non stéroïdiens)",
            "Helicobacter pylori",
            "Le stress (ulcère de stress)",
            "L'alcool",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "complete" as const,
          title: "Ulcère peptique terminé",
          body: "Tu connais maintenant les causes de l'ulcère peptique.",
          masteredConcepts: ["gastroenterology.ulcer.h_pylori"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates IBD rectocolite fill_blank schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "MICI : Crohn et RCH",
          body: "MICI : Crohn (atteinte transmurale, lésions en saut) vs RCH (atteinte muqueuse, continue, rectum → côlon).",
          sourceRefs: [],
        },
        {
          type: "fill_blank" as const,
          questionKey: "gastro_ibd_rch_001",
          prompt: "La ___ hémorragique touche de façon continue la muqueuse du rectum et du côlon.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "MICI terminées",
          body: "Tu connais maintenant les différences entre Crohn et RCH.",
          masteredConcepts: ["gastroenterology.ibd.uc"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates cirrhosis Child-Pugh C clinical_case schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Cirrhose hépatique",
          body: "La cirrhose est une fibrose remplaçant l'architecture hépatique normale. Causes : alcool (1ère cause en France), virales (VHB/VHC), NASH. Scores : Child-Pugh (A/B/C) et MELD.",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "gastro_liver_cc_001",
          scenario:
            "Un homme de 52 ans, éthylique chronique, présente une ascite de grande abondance, un ictère à 80 µmol/L, une encéphalopathie de grade II et un TP à 40%. L'échographie montre un foie dysmorphique avec une rate à 18 cm.",
          question: "Quel est le stade de la cirrhose selon la classification de Child-Pugh ?",
          options: [
            "Child-Pugh A (5-6 points)",
            "Child-Pugh B (7-9 points)",
            "Child-Pugh C (10-15 points)",
            "Cirrhose non classifiable",
          ] as [string, string, string, string],
          difficulty: "hard" as const,
          xpReward: 25,
        },
        {
          type: "complete" as const,
          title: "Cirrhose terminée",
          body: "Tu connais maintenant la classification et les complications de la cirrhose.",
          masteredConcepts: ["gastroenterology.cirrhosis.child_pugh"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });
});
