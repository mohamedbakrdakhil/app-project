import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Microbiology lesson validation", () => {
  it("validates micro_bacteria lesson schema (intro + recall + fill_blank + complete)", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 4,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Les bactéries — Gram+/Gram-",
          body: "La coloration de Gram permet de classer les bactéries en deux grands groupes.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "micro_gram_pos_001",
          question: "Gram+ bacteria cell wall ?",
          options: [
            "Épaisse paroi de peptidoglycane",
            "Fine paroi avec membrane externe",
            "Absence de paroi",
            "Paroi de chitine",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "micro_gram_stain_001",
          prompt: "La coloration de ___ différencie les bactéries en deux grands groupes.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Bactéries terminées",
          body: "Tu connais maintenant la classification de Gram.",
          masteredConcepts: ["microbiology.bacteria.gram_positive"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates fill_blank answer key for Gram staining", () => {
    const key = {
      micro_gram_stain_001: {
        acceptedAnswers: ["Gram"],
        explanation: "La coloration de Gram différencie les bactéries selon la composition de leur paroi.",
        conceptKey: "microbiology.bacteria.gram_staining",
        sourceRefs: [],
      },
      micro_gram_pos_001: {
        correctIndex: 0,
        explanation: "Les bactéries Gram+ possèdent une épaisse couche de peptidoglycane.",
        conceptKey: "microbiology.bacteria.gram_positive.cell_wall",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates antibiotic clinical_case step", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Les antibiotiques",
          body: "Les bêta-lactamines inhibent la synthèse de la paroi bactérienne.",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "micro_amox_cc_001",
          scenario:
            "Une femme de 28 ans a une infection urinaire à E. coli résistante à l'amoxicilline par bêta-lactamase, mais sensible à amoxicilline-acide clavulanique.",
          question: "Pourquoi l'amoxicilline + acide clavulanique est-elle efficace ?",
          options: [
            "L'acide clavulanique augmente l'absorption",
            "L'acide clavulanique inhibe la bêta-lactamase",
            "L'association double la dose",
            "L'acide clavulanique perméabilise la membrane",
          ] as [string, string, string, string],
          xpReward: 25,
          difficulty: "medium" as const,
        },
        {
          type: "complete" as const,
          title: "Antibiotiques terminés",
          body: "Tu connais maintenant les grandes classes d'antibiotiques.",
          masteredConcepts: ["microbiology.antibiotics.beta_lactams"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });
});
