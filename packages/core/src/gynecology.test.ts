import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Gynécologie-Obstétrique lesson validation", () => {
  it("validates pregnancy lesson schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Grossesse normale",
          body: "La grossesse dure normalement 40 semaines d'aménorrhée (SA). Diagnostic : beta-hCG. Mouvements fœtaux vers 20 SA. Prise de poids 10-12 kg. 3 échographies obligatoires : 12, 22 et 32 SA.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "gyn_ultrasound_001",
          question: "Nombre d'échographies obligatoires pendant la grossesse en France ?",
          options: [
            "1 échographie (12 SA)",
            "2 échographies (12, 22 SA)",
            "3 échographies (12, 22, 32 SA)",
            "4 échographies (12, 20, 28, 36 SA)",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "gyn_duration_001",
          prompt: "La grossesse dure normalement ___ semaines d'aménorrhée.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Grossesse normale terminée",
          body: "Tu connais maintenant les bases du suivi de la grossesse normale.",
          masteredConcepts: ["gynecology.pregnancy.duration", "gynecology.pregnancy.ultrasounds"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();

    const key = {
      gyn_ultrasound_001: {
        correctIndex: 2,
        explanation: "3 échographies obligatoires : 12, 22 et 32 SA.",
        conceptKey: "gynecology.pregnancy.ultrasounds",
        sourceRefs: [],
      },
      gyn_duration_001: {
        acceptedAnswers: ["40", "quarante"],
        explanation: "La grossesse dure normalement 40 semaines d'aménorrhée.",
        conceptKey: "gynecology.pregnancy.duration",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates labor fill_blank answer key (10 cm)", () => {
    const key = {
      gyn_apgar_001: {
        correctIndex: 0,
        explanation: "Le score d'APGAR évalue l'état du nouveau-né à 1 et 5 minutes de vie.",
        conceptKey: "gynecology.labor.apgar",
        sourceRefs: [],
      },
      gyn_dilation_001: {
        acceptedAnswers: ["10", "dix"],
        explanation: "La dilatation cervicale progresse de 0 à 10 cm lors du travail.",
        conceptKey: "gynecology.labor.phases",
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
          title: "Travail obstétrical",
          body: "Le travail obstétrical : dilatation cervicale 0 à 10 cm. Score APGAR coté à 1 et 5 minutes.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "gyn_apgar_001",
          question: "Score utilisé pour évaluer l'état du nouveau-né à la naissance ?",
          options: [
            "Score d'APGAR",
            "Score de Glasgow",
            "Score de Bishop",
            "Score de SOFA",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "gyn_dilation_001",
          prompt: "Le travail obstétrical est divisé en phases de dilatation cervicale de 0 à ___ cm.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Travail obstétrical terminé",
          body: "Tu connais maintenant les phases du travail.",
          masteredConcepts: ["gynecology.labor.phases"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates pre-eclampsia clinical_case", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Complications obstétricales",
          body: "La pré-éclampsie associe PA ≥ 140/90 mmHg et protéinurie après 20 SA. L'éclampsie ajoute des convulsions.",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "gyn_preeclampsia_cc_001",
          scenario:
            "Une primigeste de 32 ans à 34 SA présente à la consultation: PA 155/100 mmHg, œdèmes des membres inférieurs importants, bandelette urinaire: protéinurie 3+. Elle se plaint de céphalées et de phosphènes.",
          question: "Quel diagnostic devez-vous évoquer en urgence ?",
          options: [
            "Hypertension gestationnelle simple",
            "Pré-éclampsie sévère",
            "Éclampsie",
            "Cholestase gravidique",
          ] as [string, string, string, string],
          difficulty: "hard" as const,
          xpReward: 25,
        },
        {
          type: "complete" as const,
          title: "Complications obstétricales terminées",
          body: "Tu connais maintenant les principales complications de la grossesse.",
          masteredConcepts: ["gynecology.complications.preeclampsia"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();

    const key = {
      gyn_preeclampsia_cc_001: {
        correctIndex: 1,
        explanation:
          "La pré-éclampsie sévère : PA ≥ 160/110 et/ou signes fonctionnels. L'éclampsie nécessiterait des convulsions.",
        conceptKey: "gynecology.complications.preeclampsia.severe",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });
});
