import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Hématologie lesson validation", () => {
  it("validates anemia lesson schema (macrocytaire fill_blank)", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Anémies",
          body: "L'anémie est définie par une Hb <12 g/dL chez la femme et <13 g/dL chez l'homme. Classification par VGM : microcytaire (carence en fer, thalassémie), normocytaire (IRA, hémolyse), macrocytaire (carence B12/folates, alcool). La carence en fer est la cause la plus fréquente dans le monde.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "hema_anemia_cause_001",
          question: "Cause mondiale la plus fréquente d'anémie ?",
          options: [
            "La carence en fer (anémie ferriprive)",
            "La carence en vitamine B12",
            "La thalassémie",
            "L'hémolyse auto-immune",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "hema_anemia_b12_001",
          prompt: "L'anémie par carence en vitamine B12 est de type ___ (augmentation du VGM).",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Anémies terminées",
          body: "Tu connais maintenant la classification et les causes des anémies.",
          masteredConcepts: ["hematology.anemia.iron_deficiency", "hematology.anemia.classification"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();

    const key = {
      hema_anemia_cause_001: {
        correctIndex: 0,
        explanation: "La carence en fer (anémie ferriprive) est la cause la plus fréquente d'anémie dans le monde.",
        conceptKey: "hematology.anemia.iron_deficiency",
        sourceRefs: [],
      },
      hema_anemia_b12_001: {
        acceptedAnswers: ["macrocytaire"],
        explanation: "La carence en vitamine B12 entraîne une anémie macrocytaire (VGM >100 fL).",
        conceptKey: "hematology.anemia.macrocytic",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates coagulation INR recall", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Coagulation et hémostase",
          body: "L'hémostase comprend : hémostase primaire (clou plaquettaire) → secondaire (cascade de coagulation, caillot de fibrine) → fibrinolyse. Le TP/INR explore la voie extrinsèque. Le TCA explore la voie intrinsèque. La warfarine est un anti-vitamine K surveillé par l'INR. L'héparine active l'antithrombine.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "hema_coag_inr_001",
          question: "Paramètre biologique surveillé sous warfarine (anti-vitamine K) ?",
          options: [
            "Le TCA (temps de céphaline activée)",
            "Le fibrinogène",
            "L'INR (International Normalized Ratio)",
            "Le temps de saignement",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "hema_coag_heparin_001",
          prompt: "L'héparine agit en activant l'___, inhibiteur naturel de la coagulation.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Coagulation terminée",
          body: "Tu connais maintenant les bases de l'hémostase et la surveillance des anticoagulants.",
          masteredConcepts: ["hematology.coagulation.inr", "hematology.coagulation.heparin"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();

    const key = {
      hema_coag_inr_001: {
        correctIndex: 2,
        explanation: "L'INR est le paramètre de surveillance des anti-vitamines K. Cible thérapeutique : 2-3.",
        conceptKey: "hematology.coagulation.inr",
        sourceRefs: [],
      },
      hema_coag_heparin_001: {
        acceptedAnswers: ["antithrombine"],
        explanation: "L'héparine potentialise l'effet de l'antithrombine III, inhibant la thrombine et le facteur Xa.",
        conceptKey: "hematology.coagulation.heparin",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates Hodgkin lymphoma clinical_case", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Leucémies et lymphomes",
          body: "Leucémies : aiguës (LAM/LAL, blastes >20%) vs chroniques (LMC/LLC). Lymphomes : Hodgkin (cellules de Reed-Sternberg, âge bimodal, guérissable) vs Non-Hodgkin. Myélome multiple : critères CRAB.",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "hema_hodgkin_cc_001",
          scenario:
            "Un homme de 25 ans consulte pour fièvre persistante, sueurs nocturnes et amaigrissement de 8 kg en 2 mois. L'examen trouve des adénopathies cervicales bilatérales non douloureuses de 3 cm et une splénomégalie. La biopsie ganglionnaire montre des cellules de Reed-Sternberg.",
          question: "Quel diagnostic correspond à ce tableau clinique ?",
          options: [
            "Leucémie aiguë lymphoblastique",
            "Lymphome de Hodgkin",
            "Lymphome non hodgkinien diffus à grandes cellules B",
            "Sarcoïdose",
          ] as [string, string, string, string],
          difficulty: "medium" as const,
          xpReward: 25,
        },
        {
          type: "recall" as const,
          questionKey: "hema_hodgkin_cell_001",
          question: "Cellule histologique caractéristique du lymphome de Hodgkin ?",
          options: [
            "La cellule de Reed-Sternberg",
            "Le lymphocyte B malin",
            "Le myéloblaste",
            "Le plasmocyte",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "complete" as const,
          title: "Leucémies et lymphomes terminés",
          body: "Tu connais maintenant les principales hémopathies malignes.",
          masteredConcepts: ["hematology.lymphoma.hodgkin", "hematology.leukemia.classification"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();

    const key = {
      hema_hodgkin_cc_001: {
        correctIndex: 1,
        explanation: "La présence de cellules de Reed-Sternberg est pathognomonique du lymphome de Hodgkin.",
        conceptKey: "hematology.lymphoma.hodgkin",
        sourceRefs: [],
      },
      hema_hodgkin_cell_001: {
        correctIndex: 0,
        explanation: "La cellule de Reed-Sternberg est la cellule géante binucléée caractéristique du lymphome de Hodgkin.",
        conceptKey: "hematology.lymphoma.hodgkin",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });
});
