import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Pulmonology lesson validation", () => {
  it("validates COPD FEV1/FVC recall schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "BPCO",
          body: "La BPCO est une obstruction bronchique irréversible définie par un rapport VEMS/CVF < 0,70 post-bronchodilatateur. Les stades GOLD I-IV sont déterminés par le % du VEMS prédit. Le tabagisme est la cause principale.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "pulm_copd_spirometry_001",
          question: "Rapport spirométrique définissant l'obstruction bronchique dans la BPCO ?",
          options: [
            "VEMS/CVF > 0,80",
            "VEMS/CVF < 0,70",
            "CVF < 80% de la théorique",
            "VEMS < 50% de la théorique",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "complete" as const,
          title: "BPCO terminée",
          body: "Tu connais maintenant les critères diagnostiques de la BPCO.",
          masteredConcepts: ["pulmonology.copd.spirometry"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates asthma fill_blank (bronchique) schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Asthme",
          body: "L'asthme est une obstruction bronchique réversible avec hyperréactivité bronchique et inflammation.",
          sourceRefs: [],
        },
        {
          type: "fill_blank" as const,
          questionKey: "pulm_asthma_hyper_001",
          prompt: "L'asthme est caractérisé par une hyperréactivité ___ avec obstruction réversible.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Asthme terminé",
          body: "Tu connais maintenant les mécanismes de l'asthme.",
          masteredConcepts: ["pulmonology.asthma.diagnosis"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates pneumonia Streptococcus clinical_case schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Pneumonies communautaires",
          body: "Les PAC : Streptococcus pneumoniae est l'agent le plus fréquent. Diagnostic : radio thoracique (opacité alvéolaire). Sévérité : score CURB-65.",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "pulm_pneumonia_cc_001",
          scenario:
            "Un homme de 55 ans fumeur se présente avec fièvre à 39.5°C, toux productive avec expectorations rouillées, douleur thoracique droite à l'inspiration et une opacité alvéolaire lobaire droite sur la radiographie. La CRP est à 280 mg/L.",
          question: "Quel est l'agent pathogène le plus probable dans cette pneumonie communautaire typique ?",
          options: [
            "Mycoplasma pneumoniae",
            "Streptococcus pneumoniae",
            "Legionella pneumophila",
            "Staphylococcus aureus",
          ] as [string, string, string, string],
          difficulty: "easy" as const,
          xpReward: 25,
        },
        {
          type: "complete" as const,
          title: "Pneumonies terminées",
          body: "Tu connais maintenant les agents pathogènes des PAC.",
          masteredConcepts: ["pulmonology.pneumonia.pathogens"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });
});
