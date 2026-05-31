import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Pédiatrie lesson validation", () => {
  it("validates growth lesson schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Croissance de l'enfant",
          body: "Poids naissance : 3,3 kg, double à 5 mois, triple à 1 an. Taille : 50 cm, +25 cm an 1, +12 cm an 2. PC : 35 cm naissance, 47 cm à 1 an. Puberté : filles 10-14 ans, garçons 11-15 ans.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "peds_birthweight_001",
          question: "Poids moyen d'un nourrisson à la naissance ?",
          options: [
            "2.5 kg",
            "3.3 kg",
            "4.0 kg",
            "2.8 kg",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "peds_weighttriple_001",
          prompt: "Le poids de naissance est triplé à l'âge d'___ an.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Croissance terminée",
          body: "Tu connais maintenant les paramètres de croissance de l'enfant.",
          masteredConcepts: ["pediatrics.growth.weight"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();

    const key = {
      peds_birthweight_001: {
        correctIndex: 1,
        explanation:
          "Le poids moyen de naissance est de 3,3 kg. Il double à 5 mois et triple à 1 an.",
        conceptKey: "pediatrics.growth.weight.birth",
        sourceRefs: [],
      },
      peds_weighttriple_001: {
        acceptedAnswers: ["1", "un"],
        explanation: "Le poids triple à l'âge d'1 an.",
        conceptKey: "pediatrics.growth.weight.triple",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates milestones recall schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Développement psychomoteur",
          body: "Sourire 2 mois, tête 4 mois, assis avec appui 6 mois, quatre pattes 9 mois, marche avec appui 12 mois, marche seul 18 mois, phrases 2 mots à 2 ans, phrases à 3 ans. Babillage 6 mois, premiers mots 12 mois.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "peds_walk_001",
          question: "À quel âge un enfant marche-t-il seul en moyenne ?",
          options: [
            "12 mois",
            "15 mois",
            "18 mois",
            "24 mois",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "peds_firstwords_001",
          prompt: "Les premiers mots apparaissent en moyenne vers ___ mois.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Développement psychomoteur terminé",
          body: "Tu connais maintenant les étapes clés du développement psychomoteur.",
          masteredConcepts: ["pediatrics.milestones.motor"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();

    const key = {
      peds_walk_001: {
        correctIndex: 2,
        explanation:
          "La marche autonome s'acquiert en moyenne à 18 mois.",
        conceptKey: "pediatrics.milestones.motor.walking",
        sourceRefs: [],
      },
      peds_firstwords_001: {
        acceptedAnswers: ["12"],
        explanation: "Les premiers mots apparaissent vers 12 mois.",
        conceptKey: "pediatrics.milestones.language.first_words",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates whooping cough clinical_case step", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Vaccinations de l'enfant",
          body: "DTPCoq (2, 4, 11 mois), Hib, PCV13 (2, 4, 11 mois), MenC (5 mois), ROR (12, 16-18 mois), Varicelle (12 mois), HPV (11-14 ans), Grippe (annuel 6 mois+risque).",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "peds_pertussis_cc_001",
          scenario:
            "Un nourrisson de 3 mois est amené aux urgences avec une fièvre à 39°C, une toux quinteuse suivie de reprise inspiratoire (chant du coq) et des vomissements post-tussifs. Il n'est pas encore vacciné.",
          question: "Quel agent pathogène est le plus probable ?",
          options: [
            "Virus de la rougeole",
            "Bordetella pertussis (coqueluche)",
            "Haemophilus influenzae",
            "Streptococcus pneumoniae",
          ] as [string, string, string, string],
          difficulty: "easy" as const,
          xpReward: 25,
        },
        {
          type: "complete" as const,
          title: "Vaccinations terminées",
          body: "Tu connais maintenant le calendrier vaccinal et les agents pathogènes.",
          masteredConcepts: ["pediatrics.vaccines.pertussis"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });
});
