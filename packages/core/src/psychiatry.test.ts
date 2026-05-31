import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Psychiatrie lesson validation", () => {
  it("validates depression lesson schema (anhedonia fill_blank)", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Épisode dépressif caractérisé",
          body: "L'épisode dépressif caractérisé nécessite ≥ 5 critères pendant ≥ 2 semaines, incluant l'humeur dépressive et/ou l'anhédonie.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "psych_dep_duration_001",
          question: "Durée minimale pour poser le diagnostic d'épisode dépressif caractérisé ?",
          options: [
            "1 semaine",
            "2 semaines",
            "1 mois",
            "3 mois",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "psych_anhedonia_001",
          prompt: "L'___ est l'incapacité à ressentir du plaisir, symptôme cardinal de la dépression.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Dépression terminée",
          body: "Tu connais maintenant les critères diagnostiques de l'épisode dépressif caractérisé.",
          masteredConcepts: ["psychiatry.depression.dsm5_criteria", "psychiatry.depression.anhedonia"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();

    const key = {
      psych_dep_duration_001: {
        correctIndex: 1,
        explanation: "Le diagnostic d'épisode dépressif caractérisé requiert au moins 5 symptômes pendant 2 semaines minimum.",
        conceptKey: "psychiatry.depression.dsm5_criteria",
        sourceRefs: [],
      },
      psych_anhedonia_001: {
        acceptedAnswers: ["anhédonie"],
        explanation: "L'anhédonie est l'incapacité à ressentir du plaisir, symptôme cardinal de la dépression.",
        conceptKey: "psychiatry.depression.anhedonia",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates bipolar recall (7 days)", () => {
    const key = {
      psych_mania_duration_001: {
        correctIndex: 0,
        explanation: "Un épisode maniaque doit durer au minimum 7 jours selon le DSM-5.",
        conceptKey: "psychiatry.bipolar.mania_criteria",
        sourceRefs: [],
      },
      psych_lithium_001: {
        acceptedAnswers: ["lithium"],
        explanation: "Le lithium est le thymorégulateur de référence du trouble bipolaire.",
        conceptKey: "psychiatry.bipolar.lithium",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();

    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Trouble bipolaire",
          body: "Le trouble bipolaire alterne épisodes dépressifs et maniaques. La manie dure ≥ 7 jours. Le lithium est le thymorégulateur de référence.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "psych_mania_duration_001",
          question: "Durée minimale d'un épisode maniaque pour le diagnostic de trouble bipolaire I ?",
          options: [
            "7 jours (1 semaine)",
            "3 jours",
            "2 semaines",
            "1 mois",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "psych_lithium_001",
          prompt: "Le ___ est le traitement thymorégulateur de référence du trouble bipolaire.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Trouble bipolaire terminé",
          body: "Tu connais maintenant les caractéristiques du trouble bipolaire.",
          masteredConcepts: ["psychiatry.bipolar.mania_criteria"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates panic disorder clinical_case", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Troubles anxieux",
          body: "Les troubles anxieux incluent TAG, trouble panique, phobies et PTSD. Traitement : ISRS + TCC.",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "psych_panic_cc_001",
          scenario:
            "Une femme de 28 ans décrit des épisodes récurrents de palpitations, dyspnée, douleur thoracique et sensation de mort imminente survenant sans déclencheur apparent, durant 10-15 minutes. Elle a peur d'avoir une pathologie cardiaque mais le bilan est normal.",
          question: "Quel trouble psychiatrique correspond à ce tableau ?",
          options: [
            "Trouble anxieux généralisé",
            "Phobie sociale",
            "Trouble panique",
            "Stress post-traumatique",
          ] as [string, string, string, string],
          difficulty: "easy" as const,
          xpReward: 25,
        },
        {
          type: "recall" as const,
          questionKey: "psych_ssri_001",
          question: "Traitement médicamenteux de première intention des troubles anxieux ?",
          options: [
            "Les benzodiazépines",
            "Les inhibiteurs sélectifs de la recapture de la sérotonine (ISRS)",
            "Les antipsychotiques",
            "Les stabilisateurs de l'humeur",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "complete" as const,
          title: "Troubles anxieux terminés",
          body: "Tu connais maintenant les principaux troubles anxieux et leurs traitements.",
          masteredConcepts: ["psychiatry.anxiety.panic_disorder"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();

    const key = {
      psych_panic_cc_001: {
        correctIndex: 2,
        explanation:
          "Le trouble panique est caractérisé par des attaques de panique récurrentes et inattendues.",
        conceptKey: "psychiatry.anxiety.panic_disorder",
        sourceRefs: [],
      },
      psych_ssri_001: {
        correctIndex: 1,
        explanation: "Les ISRS sont le traitement médicamenteux de première intention des troubles anxieux.",
        conceptKey: "psychiatry.anxiety.treatment_ssri",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });
});
