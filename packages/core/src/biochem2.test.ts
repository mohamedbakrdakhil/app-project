import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Biochimie 2 — Glucides et Lipides lesson validation", () => {
  it("validates glycolysis lesson schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "La glycolyse",
          body: "La glycolyse transforme le glucose en pyruvate en 10 étapes avec un gain net de 2 ATP.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "gl_atp_001",
          question: "Quel est le gain net en ATP de la glycolyse pour une molécule de glucose ?",
          options: ["1 ATP", "2 ATP", "4 ATP", "38 ATP"] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "gl_pyruvate_001",
          prompt: "La glycolyse transforme le ___ en pyruvate.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Glycolyse maîtrisée",
          body: "Tu connais maintenant les bases de la glycolyse.",
          masteredConcepts: ["biochemistry.glucides.glycolysis.atp_yield"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates Krebs cycle lesson schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Le cycle de Krebs",
          body: "Le cycle de Krebs se déroule dans la matrice mitochondriale et produit NADH, FADH2, GTP et CO2.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "krebs_location_001",
          question: "Où se déroule le cycle de Krebs dans la cellule ?",
          options: ["Le cytoplasme", "La matrice mitochondriale", "La membrane plasmique", "Le réticulum endoplasmique"] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "krebs_cofactor_001",
          prompt: "Le cycle de Krebs produit du CO₂ et des cofacteurs réduits comme le ___.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Cycle de Krebs maîtrisé",
          body: "Tu comprends maintenant le cycle de Krebs.",
          masteredConcepts: ["biochemistry.glucides.krebs.location", "biochemistry.glucides.krebs.products"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates glucides-lipides answer keys", () => {
    const key = {
      gl_atp_001: {
        correctIndex: 1,
        explanation: "La glycolyse produit 4 ATP bruts mais en consomme 2, soit un gain net de 2 ATP.",
        conceptKey: "biochemistry.glucides.glycolysis.atp_yield",
        sourceRefs: [],
      },
      gl_pyruvate_001: {
        acceptedAnswers: ["glucose"],
        explanation: "La glycolyse transforme le glucose en deux molécules de pyruvate.",
        conceptKey: "biochemistry.glucides.glycolysis.overview",
        sourceRefs: [],
      },
      lipids_membrane_001: {
        correctIndex: 2,
        explanation: "Les phospholipides forment la bicouche lipidique des membranes cellulaires.",
        conceptKey: "biochemistry.lipids.membrane_composition",
        sourceRefs: [],
      },
      lipids_storage_001: {
        acceptedAnswers: ["adipeux"],
        explanation: "Les triglycérides sont stockés dans le tissu adipeux.",
        conceptKey: "biochemistry.lipids.classes",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });
});
