import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Néphrologie lesson validation", () => {
  it("validates renal physiology lesson schema (EPO recall)", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Physiologie rénale",
          body: "Le rein assure la filtration glomérulaire (DFG ~120 mL/min), la réabsorption (glucose, Na+, eau), la sécrétion et la régulation de la PA via le système RAAS. Il produit l'érythropoïétine (EPO) stimulant la production de globules rouges et active la vitamine D. Le néphron est l'unité fonctionnelle du rein.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "neph_epo_001",
          question: "Hormone produite par le rein pour stimuler la production de globules rouges ?",
          options: [
            "L'aldostérone",
            "L'érythropoïétine (EPO)",
            "L'angiotensine II",
            "La rénine",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "neph_gfr_001",
          prompt: "Le débit de filtration glomérulaire (DFG) normal est d'environ ___ mL/min.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Physiologie rénale terminée",
          body: "Tu connais maintenant les fonctions essentielles du rein.",
          masteredConcepts: ["nephrology.physiology.gfr", "nephrology.physiology.epo"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();

    const key = {
      neph_epo_001: {
        correctIndex: 1,
        explanation: "L'érythropoïétine (EPO) est produite par les cellules péritubulaires du rein.",
        conceptKey: "nephrology.physiology.epo",
        sourceRefs: [],
      },
      neph_gfr_001: {
        acceptedAnswers: ["120", "100-120"],
        explanation: "Le DFG normal est d'environ 120 mL/min.",
        conceptKey: "nephrology.physiology.gfr",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates AKI fill_blank (expansion/remplissage)", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Insuffisance rénale aiguë",
          body: "L'IRA est définie par une élévation brutale de la créatinine. Causes : prérénale (déshydratation, choc), intrinsèque (NTA), postrénale (obstruction). Traitement de l'IRA prérénale : expansion hydrique.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "neph_aki_cause_001",
          question: "Cause la plus fréquente d'insuffisance rénale aiguë en réanimation ?",
          options: [
            "La nécrose tubulaire aiguë (NTA) pré-rénale",
            "La glomérulonéphrite aiguë",
            "L'obstruction urétérale bilatérale",
            "La pyélonéphrite aiguë",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "neph_aki_treatment_001",
          prompt: "L'insuffisance rénale aiguë pré-rénale est traitée en priorité par une ___ hydrique.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "IRA terminée",
          body: "Tu connais maintenant les critères diagnostiques et les causes de l'insuffisance rénale aiguë.",
          masteredConcepts: ["nephrology.aki.kdigo", "nephrology.aki.prerenal"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();

    const key = {
      neph_aki_cause_001: {
        correctIndex: 0,
        explanation: "La NTA d'origine pré-rénale est la cause la plus fréquente d'IRA en réanimation.",
        conceptKey: "nephrology.aki.prerenal",
        sourceRefs: [],
      },
      neph_aki_treatment_001: {
        acceptedAnswers: ["expansion", "remplissage"],
        explanation: "L'IRA pré-rénale est traitée par expansion hydrique (remplissage vasculaire).",
        conceptKey: "nephrology.aki.treatment",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates CKD stage 4 clinical_case", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Maladie rénale chronique",
          body: "La MRC est définie par un DFG <60 mL/min/1,73 m² pendant plus de 3 mois. 5 stades G1-G5. Causes : néphropathie diabétique (#1), néphrosclérose hypertensive (#2).",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "neph_ckd_stage_001",
          scenario:
            "Un homme de 60 ans diabétique depuis 15 ans présente une créatinine à 250 µmol/L (DFG estimé à 25 mL/min/1.73m²), une protéinurie à 2 g/24h, une anémie normochrome normocytaire (Hb 9 g/dL) et une pression artérielle à 155/90 mmHg.",
          question: "Quel stade de maladie rénale chronique présente ce patient ?",
          options: [
            "Stade G1 (DFG ≥90)",
            "Stade G3b (DFG 30-44)",
            "Stade G4 (DFG 15-29)",
            "Stade G5 (DFG <15)",
          ] as [string, string, string, string],
          difficulty: "medium" as const,
          xpReward: 25,
        },
        {
          type: "recall" as const,
          questionKey: "neph_ckd_cause_001",
          question: "Cause numéro 1 de maladie rénale chronique dans les pays développés ?",
          options: [
            "La glomérulonéphrite chronique",
            "La néphropathie diabétique",
            "La néphrosclérose hypertensive",
            "La polykystose rénale",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "complete" as const,
          title: "MRC terminée",
          body: "Tu connais maintenant les stades et la prise en charge de la maladie rénale chronique.",
          masteredConcepts: ["nephrology.ckd.staging", "nephrology.ckd.causes"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();

    const key = {
      neph_ckd_stage_001: {
        correctIndex: 2,
        explanation: "Un DFG à 25 mL/min/1,73 m² correspond au stade G4 (DFG 15-29).",
        conceptKey: "nephrology.ckd.staging",
        sourceRefs: [],
      },
      neph_ckd_cause_001: {
        correctIndex: 1,
        explanation: "La néphropathie diabétique est la première cause de MRC dans les pays développés.",
        conceptKey: "nephrology.ckd.causes",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });
});
