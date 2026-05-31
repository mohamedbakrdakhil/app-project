import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Immunology lesson validation", () => {
  it("validates innate immunity lesson schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 4,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "L'immunité innée",
          body: "L'immunité innée comprend les barrières physiques, les phagocytes (neutrophiles, macrophages), les cellules NK et le système du complément. Les récepteurs PRR reconnaissent les PAMP.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "immu_macro_001",
          question: "Quelle est la principale cellule phagocytaire dans les tissus ?",
          options: ["Le neutrophile", "Le macrophage", "La cellule NK", "Le lymphocyte T"] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "immu_prr_001",
          prompt: "Les ___ reconnaissent les motifs moléculaires associés aux pathogènes (PAMP).",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Immunité innée terminée",
          body: "Tu connais maintenant les composants principaux de l'immunité innée.",
          masteredConcepts: ["immunology.innate.phagocytes", "immunology.innate.prr_pamp"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates adaptive immunity lesson schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "L'immunité adaptative",
          body: "Les lymphocytes T (CD4+, CD8+) et B (→ plasmocytes → anticorps). CMH I sur toutes les cellules nucléées, CMH II sur les cellules présentatrices d'antigènes.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "immu_dc_001",
          question: "Quelle cellule présente les antigènes via le CMH de classe II ?",
          options: ["Le lymphocyte T CD8+", "Le neutrophile", "La cellule dendritique", "La cellule NK"] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "immu_b_001",
          prompt: "Les lymphocytes ___ produisent les anticorps après différenciation en plasmocytes.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Immunité adaptative terminée",
          body: "Tu connais maintenant les acteurs clés de l'immunité adaptative.",
          masteredConcepts: ["immunology.adaptive.lymphocytes_t", "immunology.adaptive.lymphocytes_b"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates clinical_case anaphylaxis step schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Hypersensibilités",
          body: "4 types d'hypersensibilité : type I (IgE, anaphylaxie), type II (cytotoxique), type III (complexes immuns), type IV (retardée, lymphocytes T).",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "immu_anaph_001",
          scenario:
            "Un enfant de 8 ans développe une urticaire généralisée et un œdème laryngé 15 minutes après avoir mangé des cacahuètes. La pression artérielle chute à 80/50 mmHg.",
          question: "Quel type d'hypersensibilité est en cause ?",
          options: [
            "Hypersensibilité de type II",
            "Hypersensibilité de type III",
            "Hypersensibilité de type I (anaphylaxie)",
            "Hypersensibilité de type IV",
          ] as [string, string, string, string],
          difficulty: "medium" as const,
          xpReward: 25,
        },
        {
          type: "complete" as const,
          title: "Hypersensibilités terminées",
          body: "Tu connais maintenant les 4 types d'hypersensibilité.",
          masteredConcepts: ["immunology.hypersensitivity.type_i"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });
});
