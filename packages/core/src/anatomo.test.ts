import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Anatomopathologie générale lesson validation", () => {
  it("validates anatomo_techniques lesson schema (HE staining recall)", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Techniques histologiques",
          body: "L'hématoxyline-éosine (HE) est la coloration de référence : l'hématoxyline colore les noyaux en bleu, l'éosine colore le cytoplasme en rose.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "anatomo_he_001",
          question: "Colorant de référence en histologie ?",
          options: ["Hématoxyline-éosine (HE)", "PAS", "Trichrome de Masson", "Rouge Congo"] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "anatomo_ihc_001",
          prompt: "L'immunohistochimie utilise des ___ pour identifier des protéines spécifiques dans les tissus.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Techniques terminées",
          body: "Tu connais maintenant les principales colorations.",
          masteredConcepts: ["pathology.anatomo.techniques.he_staining"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates lesions fill_blank answer key (métaplasie)", () => {
    const key = {
      anatomo_caseous_001: {
        correctIndex: 1,
        explanation: "La nécrose caséeuse est caractéristique de la tuberculose.",
        conceptKey: "pathology.anatomo.lesions.necrosis.caseous",
        sourceRefs: [],
      },
      anatomo_metaplasie_001: {
        acceptedAnswers: ["métaplasie"],
        explanation: "La métaplasie est un processus adaptatif réversible.",
        conceptKey: "pathology.anatomo.lesions.metaplasia",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates tumor clinical_case schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 7,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Tumeurs bénignes et malignes",
          body: "Le carcinome provient d'un épithélium, le sarcome provient du mésenchyme, l'adénocarcinome provient d'un épithélium glandulaire.",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "anatomo_tumor_cc_001",
          scenario: "À l'examen histologique d'une biopsie rectale, on observe des cellules épithéliales avec des noyaux hyperchromatiques, un rapport nucléo-cytoplasmique élevé, des mitoses atypiques et une invasion de la lamina propria.",
          question: "Quel diagnostic histologique est le plus probable ?",
          options: ["Adénome tubuleux bénin", "Polype hyperplasique", "Adénocarcinome invasif", "Métaplasie intestinale"] as [string, string, string, string],
          difficulty: "hard" as const,
          xpReward: 25,
        },
        {
          type: "recall" as const,
          questionKey: "anatomo_carcinoma_001",
          question: "Tumeur maligne d'origine épithéliale ?",
          options: ["Carcinome", "Sarcome", "Lymphome", "Gliome"] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "complete" as const,
          title: "Tumeurs terminées",
          body: "Tu connais maintenant les critères de bénignité et de malignité.",
          masteredConcepts: ["pathology.anatomo.tumors.carcinoma"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });
});
