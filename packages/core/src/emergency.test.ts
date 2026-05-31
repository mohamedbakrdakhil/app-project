import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Médecine d'urgence lesson validation", () => {
  it("validates cardiac arrest lesson schema (30:2 fill_blank)", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Arrêt cardiaque",
          body: "Le ratio RCP est de 30 compressions pour 2 insufflations, à 100-120/min.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "emerg_cpr_rate_001",
          question: "Rythme des compressions thoraciques en RCP ?",
          options: [
            "60-80 compressions par minute",
            "100-120 compressions par minute",
            "120-140 compressions par minute",
            "80-100 compressions par minute",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "emerg_cpr_ratio_001",
          prompt: "En RCP, le ratio compressions/insufflations est de ___ / 2.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Arrêt cardiaque terminé",
          body: "Tu connais maintenant les étapes de la chaîne de survie.",
          masteredConcepts: ["emergency.cardiac_arrest.bls_chain"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();

    const key = {
      emerg_cpr_ratio_001: {
        acceptedAnswers: ["30"],
        explanation: "Le ratio standard est 30:2.",
        conceptKey: "emergency.cardiac_arrest.cpr_ratio",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates shock clinical_case step", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "État de choc",
          body: "4 types : hypovolémique, cardiogénique, distributif, obstructif.",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "emerg_shock_cc_001",
          scenario:
            "Un homme de 70 ans est hospitalisé pour rectorragies abondantes. PA 80/50 mmHg, FC 130/min, extrémités froides, marbrures. Hémoglobine 6 g/dL.",
          question: "Quel type de choc présente ce patient ?",
          options: [
            "Choc cardiogénique",
            "Choc hypovolémique hémorragique",
            "Choc septique",
            "Choc anaphylactique",
          ] as [string, string, string, string],
          difficulty: "medium" as const,
          xpReward: 25,
        },
        {
          type: "complete" as const,
          title: "État de choc terminé",
          body: "Tu connais maintenant les types de choc.",
          masteredConcepts: ["emergency.shock.types"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates respiratory recall schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Détresse respiratoire aiguë",
          body: "SpO2 < 90% définit l'hypoxémie sévère. Causes : asthme, BPCO, pneumothorax, EP.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "emerg_spo2_001",
          question: "Valeur SpO2 définissant l'hypoxémie sévère ?",
          options: [
            "Inférieure à 95%",
            "Inférieure à 92%",
            "Inférieure à 90%",
            "Inférieure à 85%",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "emerg_pneumo_001",
          prompt:
            "Le pneumothorax compressif entraîne un déplacement de la ___ controlatérale.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Détresse respiratoire terminée",
          body: "Tu connais les signes de détresse respiratoire.",
          masteredConcepts: ["emergency.respiratory.hypoxia"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });
});
