import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Dermatologie lesson validation", () => {
  it("validates primary lesions lesson schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Lésions primitives",
          body: "La macule est une lésion plane avec changement de couleur. La papule est surélevée < 1 cm. La plaque est surélevée > 1 cm. La vésicule contient du liquide clair < 0,5 cm. La bulle > 0,5 cm. La pustule contient du pus.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "derm_macule_001",
          question: "Lésion plane avec changement de couleur ?",
          options: [
            "La papule",
            "La macule",
            "La plaque",
            "La vésicule",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "derm_pustule_001",
          prompt: "Une vésicule contenant du ___ est appelée pustule.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Lésions primitives terminées",
          body: "Tu connais maintenant les lésions primitives cutanées.",
          masteredConcepts: ["dermatology.primary_lesions.macule"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();

    const key = {
      derm_macule_001: {
        correctIndex: 1,
        explanation: "La macule est une lésion plane avec changement de couleur.",
        conceptKey: "dermatology.primary_lesions.macule",
        sourceRefs: [],
      },
      derm_pustule_001: {
        acceptedAnswers: ["pus"],
        explanation: "La pustule est une vésicule contenant du pus.",
        conceptKey: "dermatology.primary_lesions.pustule",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates secondary lesions fill_blank answer key", () => {
    const key = {
      derm_ulcer_001: {
        correctIndex: 2,
        explanation:
          "L'ulcère est une perte de substance profonde atteignant le derme.",
        conceptKey: "dermatology.secondary_lesions.ulcer",
        sourceRefs: [],
      },
      derm_croute_001: {
        acceptedAnswers: ["croûte"],
        explanation:
          "La croûte résulte du dessèchement des exsudats à la surface cutanée.",
        conceptKey: "dermatology.secondary_lesions.crust",
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
          title: "Lésions secondaires",
          body: "La squame (hyperkératose), la croûte (exsudats desséchés), l'érosion (épiderme superficiel), l'ulcère (derme profond), la lichénification (épaississement cutané), la cicatrice, l'atrophie.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "derm_ulcer_001",
          question: "Perte de substance atteignant le derme ?",
          options: [
            "La squame",
            "L'érosion",
            "L'ulcère",
            "La lichénification",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "derm_croute_001",
          prompt:
            "La ___ résulte du dessèchement des exsudats (sérum, pus ou sang) à la surface cutanée.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Lésions secondaires terminées",
          body: "Tu connais maintenant les lésions secondaires cutanées.",
          masteredConcepts: ["dermatology.secondary_lesions.ulcer"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates Köbner clinical_case step", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Maladies dermatologiques courantes",
          body: "Le psoriasis : plaques érythémateuses + squames argentées, phénomène de Köbner, atteinte unguéale. Eczéma : prurigineux, chronique, IgE. Acné : glandes sébacées. Mélanome ABCDE : Asymétrie, Bords irréguliers, Couleur, Diamètre > 6 mm, Évolution.",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "derm_kobner_cc_001",
          scenario:
            "Un homme de 35 ans présente des plaques érythémateuses bien délimitées recouvertes de squames argentées sur les coudes et les genoux. Il note l'apparition de nouvelles lésions sur les zones de traumatisme (gratouillage).",
          question:
            "Quel signe clinique décrit l'apparition de lésions sur les zones de traumatisme ?",
          options: [
            "Signe de Nikolsky",
            "Phénomène de Köbner",
            "Signe de Darier",
            "Dermographisme",
          ] as [string, string, string, string],
          difficulty: "medium" as const,
          xpReward: 25,
        },
        {
          type: "complete" as const,
          title: "Maladies dermatologiques terminées",
          body: "Tu connais maintenant les principales maladies dermatologiques.",
          masteredConcepts: ["dermatology.psoriasis.kobner"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });
});
