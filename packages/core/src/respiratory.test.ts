import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Physiologie — Système respiratoire lesson validation", () => {
  it("validates ventilation lesson schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "La ventilation pulmonaire",
          body: "Le diaphragme assure l'inspiration active. Le volume courant normal est d'environ 500 mL.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "resp_muscle_001",
          question: "Quel est le principal muscle de la respiration ?",
          options: ["Le diaphragme", "Les muscles intercostaux externes", "Le grand pectoral", "Le sternocléidomastoïdien"] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "resp_volume_001",
          prompt: "Le volume courant normal est d'environ ___ mL.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Ventilation maîtrisée",
          body: "Tu connais maintenant les mécanismes de la ventilation pulmonaire.",
          masteredConcepts: ["physiology.respiratory.ventilation.mechanics"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates gas exchange lesson schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Les échanges gazeux",
          body: "L'hématose est l'échange O2/CO2 au niveau alvéolaire. L'O2 est transporté par l'hémoglobine.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "resp_o2_transport_001",
          question: "Comment l'oxygène est-il principalement transporté dans le sang ?",
          options: ["Dissous dans le plasma", "Lié à l'albumine", "Lié à l'hémoglobine dans les érythrocytes", "Sous forme de bicarbonate"] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "resp_spo2_001",
          prompt: "La saturation en O₂ normale (SpO₂) est supérieure à ___ %.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Échanges gazeux maîtrisés",
          body: "Tu comprends maintenant les échanges gazeux pulmonaires.",
          masteredConcepts: ["physiology.respiratory.gas_exchange.hematosis"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates respiratory answer keys", () => {
    const key = {
      resp_muscle_001: {
        correctIndex: 0,
        explanation: "Le diaphragme est le principal muscle respiratoire.",
        conceptKey: "physiology.respiratory.ventilation.mechanics",
        sourceRefs: [],
      },
      resp_volume_001: {
        acceptedAnswers: ["500"],
        explanation: "Le volume courant normal au repos est d'environ 500 mL.",
        conceptKey: "physiology.respiratory.ventilation.tidal_volume",
        sourceRefs: [],
      },
      resp_stimulus_001: {
        correctIndex: 1,
        explanation: "L'augmentation de la PaCO2 est le principal stimulus de la ventilation.",
        conceptKey: "physiology.respiratory.regulation.chemoreceptors",
        sourceRefs: [],
      },
      resp_center_001: {
        acceptedAnswers: ["bulbe"],
        explanation: "Le centre respiratoire principal est dans le bulbe rachidien.",
        conceptKey: "physiology.respiratory.regulation.center",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });
});
