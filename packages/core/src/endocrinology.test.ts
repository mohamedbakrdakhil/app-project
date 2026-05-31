import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Endocrinology lesson validation", () => {
  it("validates hormone types lesson schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 4,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Types d'hormones",
          body: "Trois grandes familles : hormones peptidiques (hydrophiles, récepteurs membranaires, seconds messagers), hormones stéroïdes (lipophiles, récepteurs intracellulaires, expression génique), hormones aminées (dérivées de la tyrosine : catécholamines, hormones thyroïdiennes).",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "endo_steroid_001",
          question: "Les hormones stéroïdes agissent via :",
          options: [
            "Des récepteurs membranaires",
            "Des récepteurs intracellulaires",
            "Des seconds messagers AMPc",
            "La voie des MAP kinases",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "endo_steroid_solub_001",
          prompt: "Les hormones stéroïdes sont ___ ce qui leur permet de traverser la membrane cellulaire.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Types d'hormones terminés",
          body: "Tu connais maintenant les trois grandes familles d'hormones.",
          masteredConcepts: ["endocrinology.hormones.peptide", "endocrinology.hormones.steroid"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates pancreas recall answer key", () => {
    const key = {
      endo_insulin_001: {
        correctIndex: 0,
        explanation: "L'insuline est la seule hormone hypoglycémiante sécrétée par les cellules β.",
        conceptKey: "endocrinology.pancreas.insulin.hypoglycemia",
        sourceRefs: [],
      },
      endo_dt1_001: {
        acceptedAnswers: ["bêta", "β", "beta"],
        explanation: "Le diabète de type 1 est une destruction auto-immune des cellules β.",
        conceptKey: "endocrinology.pancreas.diabetes_type1",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates thyroid clinical_case lesson schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "La thyroïde",
          body: "T3/T4 régulent le métabolisme. La TSH hypophysaire contrôle la thyroïde. Hypothyroïdie : fatigue, prise de poids, bradycardie. Hyperthyroïdie : amaigrissement, tachycardie, intolérance à la chaleur.",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "endo_thyroid_cc_001",
          scenario:
            "Une femme de 35 ans consulte pour fatigue, prise de poids de 5 kg en 3 mois, constipation et frilosité. À l'examen: bradycardie à 52/min, peau sèche, réflexes lents. TSH: 45 mUI/L (N: 0.4-4).",
          question: "Quel diagnostic est le plus probable ?",
          options: [
            "Hyperthyroïdie",
            "Hypothyroïdie",
            "Diabète de type 2",
            "Insuffisance surrénalienne",
          ] as [string, string, string, string],
          difficulty: "easy" as const,
          xpReward: 25,
        },
        {
          type: "recall" as const,
          questionKey: "endo_tsh_001",
          question: "Une TSH élevée signifie que la thyroïde est :",
          options: [
            "Hyperactive (hyperthyroïdie)",
            "Normalement fonctionnelle",
            "Sous-stimulée par la thyroïde (hypothyroïdie)",
            "En train de produire trop de T3/T4",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "complete" as const,
          title: "Thyroïde terminée",
          body: "Tu connais maintenant le fonctionnement de la glande thyroïde et ses pathologies.",
          masteredConcepts: ["endocrinology.thyroid.t3_t4", "endocrinology.thyroid.tsh"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });
});
