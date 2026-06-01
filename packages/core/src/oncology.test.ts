import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Oncologie médicale lesson validation", () => {
  it("validates carcinogenesis TP53 recall", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Carcinogenèse",
          body: "Carcinogenèse : initiation (mutation) → promotion (expansion clonale) → progression. Oncogènes (gain de fonction : RAS, HER2) vs gènes suppresseurs de tumeur (perte de fonction : TP53, RB).",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "onco_carcino_tp53_001",
          question: "Gène suppresseur de tumeur le plus fréquemment muté dans les cancers ?",
          options: [
            "TP53 (gène p53)",
            "RB (rétinoblastome)",
            "BRCA1",
            "APC",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "onco_carcino_oncogene_001",
          prompt: "Les oncogènes ont un effet ___ de fonction par rapport à leur équivalent normal.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Carcinogenèse terminée",
          body: "Tu connais maintenant les étapes de la carcinogenèse et les principales altérations moléculaires.",
          masteredConcepts: ["oncology.carcinogenesis.hallmarks", "oncology.carcinogenesis.tp53"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();

    const key = {
      onco_carcino_tp53_001: {
        correctIndex: 0,
        explanation: "TP53 est le gène suppresseur de tumeur le plus fréquemment muté dans les cancers humains, impliqué dans environ 50% des cancers.",
        conceptKey: "oncology.carcinogenesis.tp53",
        sourceRefs: [],
      },
      onco_carcino_oncogene_001: {
        acceptedAnswers: ["gain"],
        explanation: "Les oncogènes résultent d'une mutation activatrice (gain de fonction) d'un proto-oncogène normal.",
        conceptKey: "oncology.carcinogenesis.oncogenes",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates staging fill_blank (pluridisciplinaire)", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Stadification TNM",
          body: "Classification TNM : T = taille/invasion tumorale (T1-T4), N = ganglions (N0-N3), M = métastases (M0/M1). Stades I à IV. Réunion de concertation pluridisciplinaire (RCP) obligatoire.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "onco_tnm_m1_001",
          question: "Dans la classification TNM, que signifie M1 ?",
          options: [
            "Absence de métastases",
            "Métastases ganglionnaires régionales",
            "Présence de métastases à distance",
            "Métastases non évaluées",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "onco_rcp_001",
          prompt: "La prise en charge des patients atteints de cancer est discutée en réunion de concertation ___ (RCP).",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Staging terminé",
          body: "Tu connais maintenant la classification TNM et le rôle de la RCP.",
          masteredConcepts: ["oncology.staging.tnm", "oncology.staging.rcp"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();

    const key = {
      onco_tnm_m1_001: {
        correctIndex: 2,
        explanation: "M1 signifie la présence de métastases à distance dans la classification TNM.",
        conceptKey: "oncology.staging.tnm.metastasis",
        sourceRefs: [],
      },
      onco_rcp_001: {
        acceptedAnswers: ["pluridisciplinaire"],
        explanation: "La réunion de concertation pluridisciplinaire (RCP) est obligatoire en France pour toute décision thérapeutique en oncologie.",
        conceptKey: "oncology.staging.rcp",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates hormone therapy clinical_case", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Traitements oncologiques",
          body: "Chirurgie (curatif si localisé), radiothérapie (contrôle local), chimiothérapie, thérapies ciblées (imatinib, trastuzumab), immunothérapie (anti-PD1/CTLA4), hormonothérapie (sein RH+ : tamoxifène/inhibiteurs aromatase).",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "onco_treat_cc_001",
          scenario:
            "Une femme de 48 ans est diagnostiquée avec un cancer du sein de 2 cm, ganglions négatifs, RH+ (ER+ PR+), HER2 négatif, Ki67 à 12%. Elle est ménopausée depuis 2 ans.",
          question: "Quel traitement adjuvant médical est prioritairement indiqué ?",
          options: [
            "Chimiothérapie par anthracyclines",
            "Trastuzumab (Herceptin)",
            "Hormonothérapie par inhibiteur de l'aromatase",
            "Immunothérapie par anti-PD1",
          ] as [string, string, string, string],
          difficulty: "medium" as const,
          xpReward: 25,
        },
        {
          type: "recall" as const,
          questionKey: "onco_immunotherapy_001",
          question: "Immunothérapie ciblant le point de contrôle immunitaire PD-1 ?",
          options: [
            "L'ipilimumab (anti-CTLA4)",
            "Les anti-PD1 (pembrolizumab, nivolumab)",
            "Le bévacizumab (anti-VEGF)",
            "Le cetuximab (anti-EGFR)",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "complete" as const,
          title: "Traitements oncologiques terminés",
          body: "Tu connais maintenant les principales modalités de traitement en oncologie.",
          masteredConcepts: ["oncology.treatment.hormonal", "oncology.treatment.immunotherapy"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });
});
