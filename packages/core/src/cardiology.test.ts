import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Cardiology lesson validation", () => {
  it("validates systole/diastole recall step", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 4,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Systole et diastole",
          body: "Le cycle cardiaque comprend la diastole (remplissage) et la systole (contraction). B1 = fermeture valves mitrale/tricuspide. B2 = fermeture valves aortique/pulmonaire. FE normale 55-70%.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "card_b1_001",
          question: "À quoi correspond le bruit du cœur B1 ?",
          options: [
            "La fermeture des valves mitrale et tricuspide",
            "La fermeture des valves aortique et pulmonaire",
            "L'ouverture des valves sigmoïdes",
            "La contraction auriculaire",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "complete" as const,
          title: "Systole et diastole terminées",
          body: "Tu connais maintenant les phases du cycle cardiaque.",
          masteredConcepts: ["physiology.cardiac_cycle.systole_diastole"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates cardiac output fill_blank answer key", () => {
    const key = {
      card_frank_001: {
        correctIndex: 1,
        explanation: "La loi de Frank-Starling : augmentation de la précharge → augmentation du volume d'éjection.",
        conceptKey: "physiology.cardiac_cycle.frank_starling",
        sourceRefs: [],
      },
      card_dc_001: {
        acceptedAnswers: ["éjection"],
        explanation: "DC = FC × VES (volume d'éjection systolique).",
        conceptKey: "physiology.cardiac_cycle.cardiac_output_formula",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates ECG clinical_case step schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "L'ECG normal",
          body: "Onde P = dépolarisation auriculaire. QRS = dépolarisation ventriculaire. T = repolarisation ventriculaire. PR normal 0,12-0,20 s. QRS < 0,12 s.",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "card_ecg_001",
          scenario:
            "Un homme de 65 ans consulte pour palpitations. L'ECG montre une fréquence cardiaque irrégulière à 110/min, absence d'ondes P identifiables et des complexes QRS fins et irréguliers.",
          question: "Quel trouble du rythme est le plus probable ?",
          options: [
            "Tachycardie sinusale",
            "Fibrillation auriculaire",
            "Flutter auriculaire",
            "Bloc auriculo-ventriculaire",
          ] as [string, string, string, string],
          difficulty: "hard" as const,
          xpReward: 25,
        },
        {
          type: "complete" as const,
          title: "ECG terminé",
          body: "Tu connais maintenant les éléments de base de l'ECG normal.",
          masteredConcepts: ["physiology.cardiac_cycle.ecg_waves"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });
});
