import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Genetics lesson validation", () => {
  it("validates chromosomes lesson schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 4,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Les chromosomes",
          body: "Le génome humain est organisé en 46 chromosomes, regroupés en 23 paires homologues.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "gen_chrom_nb_001",
          question: "Nombre de chromosomes humains ?",
          options: [
            "23 chromosomes (haploïde)",
            "46 chromosomes (23 paires)",
            "48 chromosomes (24 paires)",
            "44 autosomes seulement",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "gen_trisomy_001",
          prompt: "La trisomie 21 résulte d'un chromosome ___ supplémentaire.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Chromosomes terminés",
          body: "Tu connais maintenant l'organisation chromosomique humaine.",
          masteredConcepts: ["genetics.chromosomes.karyotype"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates inheritance fill_blank (50%)", () => {
    const key = {
      gen_ad_risk_001: {
        acceptedAnswers: ["50"],
        explanation:
          "En transmission autosomique dominante, un parent atteint a 50 % de risque de transmettre l'allèle muté.",
        conceptKey: "genetics.inheritance.autosomal_dominant.risk",
        sourceRefs: [],
      },
      gen_mucovis_001: {
        correctIndex: 2,
        explanation: "La mucoviscidose est une maladie autosomique récessive due à des mutations du gène CFTR.",
        conceptKey: "genetics.inheritance.autosomal_recessive.cystic_fibrosis",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates BRCA clinical_case step", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Mutations et oncogènes",
          body: "BRCA1 et BRCA2 sont des gènes suppresseurs de tumeur impliqués dans la réparation de l'ADN.",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "gen_brca_cc_001",
          scenario:
            "Une femme de 32 ans est porteuse d'une mutation BRCA1. Sa mère et sa tante ont eu un cancer du sein. Le risque pour les porteuses est estimé à 60-70%.",
          question: "Quel est le mode de transmission de la mutation BRCA1 ?",
          options: [
            "Autosomique récessif",
            "Lié à l'X",
            "Autosomique dominant",
            "Mitochondrial",
          ] as [string, string, string, string],
          xpReward: 25,
          difficulty: "medium" as const,
        },
        {
          type: "complete" as const,
          title: "Mutations et oncogènes terminés",
          body: "Tu connais maintenant les types de mutations et leur rôle dans la carcinogenèse.",
          masteredConcepts: ["genetics.cancer.oncogenes"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });
});
