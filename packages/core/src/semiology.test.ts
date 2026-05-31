import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Sémiologie médicale lesson validation", () => {
  it("validates interrogatoire lesson schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "L'interrogatoire (anamnèse)",
          body: "L'anamnèse est la première étape de l'examen clinique. Elle recueille le motif de consultation, l'histoire de la maladie, les antécédents, les traitements, les allergies et l'histoire sociale.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "semio_interro_001",
          question: "Première étape de l'examen clinique ?",
          options: ["L'auscultation", "La palpation", "L'interrogatoire (anamnèse)", "La percussion"] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "semio_auscult_001",
          prompt: "L'___ est la technique qui consiste à écouter les sons produits par les organes internes.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Interrogatoire terminé",
          body: "Tu connais maintenant les éléments constitutifs de l'anamnèse.",
          masteredConcepts: ["semiology.clinical_exam.anamnesis"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates vital signs recall schema", () => {
    const key = {
      semio_bp_001: {
        correctIndex: 0,
        explanation: "La PA normale est inférieure à 120/80 mmHg.",
        conceptKey: "semiology.vital_signs.blood_pressure.normal",
        sourceRefs: [],
      },
      semio_tachy_001: {
        acceptedAnswers: ["100"],
        explanation: "La tachycardie est définie par une FC supérieure à 100 bpm au repos.",
        conceptKey: "semiology.vital_signs.tachycardia",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates pain clinical_case schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Évaluation de la douleur",
          body: "L'évaluation de la douleur repose sur l'échelle numérique (NRS) ou visuelle analogique (EVA) de 0 à 10. La mnémotechnique SOCRATES guide l'interrogatoire de la douleur.",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "semio_pain_cc_001",
          scenario: "Un patient de 55 ans se présente aux urgences avec une douleur thoracique constrictive irradiant dans le bras gauche et la mâchoire, débutée il y a 45 minutes au repos, avec sueurs et nausées. EVA 8/10.",
          question: "Quelle est la localisation anatomique la plus probable de cette douleur ?",
          options: ["Plèvre gauche", "Myocarde (ventricule gauche)", "Œsophage", "Péricarde"] as [string, string, string, string],
          difficulty: "medium" as const,
          xpReward: 25,
        },
        {
          type: "recall" as const,
          questionKey: "semio_eva_001",
          question: "Échelle de douleur numérique standard ?",
          options: ["Échelle de Glasgow (0 à 15)", "EVA/NRS de 0 à 10", "Score APACHE II", "Indice de Barthel"] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "complete" as const,
          title: "Évaluation de la douleur terminée",
          body: "Tu connais maintenant les outils d'évaluation de la douleur.",
          masteredConcepts: ["semiology.pain.eva_nrs", "semiology.pain.socrates"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });
});
