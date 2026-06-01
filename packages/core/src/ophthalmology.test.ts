import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Ophtalmologie lesson validation", () => {
  it("validates eye anatomy lesson schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Anatomie oculaire",
          body: "La cornée est transparente. L'iris contrôle le diamètre pupillaire. Le cristallin assure l'accommodation. La rétine contient les bâtonnets (vision nocturne) et les cônes (vision des couleurs). Le nerf optique (II) transmet l'information visuelle. La fovéa est la zone de vision la plus précise.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "ophtho_cones_001",
          question: "Cellules rétiniennes responsables de la vision des couleurs ?",
          options: [
            "Les bâtonnets",
            "Les cônes",
            "Les cellules ganglionnaires",
            "Les cellules de Müller",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "ophtho_fovea_001",
          prompt: "La ___ est la zone de la rétine où la vision est la plus précise.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Anatomie oculaire terminée",
          body: "Tu connais maintenant les structures fondamentales de l'œil.",
          masteredConcepts: ["ophthalmology.anatomy.fovea", "ophthalmology.anatomy.cones"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();

    const key = {
      ophtho_cones_001: {
        correctIndex: 1,
        explanation: "Les cônes sont les photorécepteurs responsables de la vision des couleurs.",
        conceptKey: "ophthalmology.anatomy.cones",
        sourceRefs: [],
      },
      ophtho_fovea_001: {
        acceptedAnswers: ["fovéa", "fovea", "macula"],
        explanation: "La fovéa est la zone centrale de la macula où la densité de cônes est maximale.",
        conceptKey: "ophthalmology.anatomy.fovea",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates refraction fill_blank (glaucome/pression intra-oculaire)", () => {
    const key = {
      ophtho_glaucoma_001: {
        acceptedAnswers: ["intra-oculaire", "intraoculaire"],
        explanation: "Le glaucome est défini par une neuropathie optique liée à une élévation de la pression intra-oculaire.",
        conceptKey: "ophthalmology.glaucoma.iop",
        sourceRefs: [],
      },
      ophtho_myopia_001: {
        correctIndex: 0,
        explanation: "La myopie est corrigée par un verre concave (divergent).",
        conceptKey: "ophthalmology.refraction.myopia",
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
          title: "Défauts de réfraction et glaucome",
          body: "Myopie : globe trop long → verre concave. Hypermétropie : globe trop court → verre convexe. Glaucome : pression intra-oculaire augmentée → lésion du nerf optique. PIO normale < 21 mmHg.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "ophtho_myopia_001",
          question: "Défaut de réfraction corrigé par un verre concave (divergent) ?",
          options: [
            "La myopie",
            "L'hypermétropie",
            "L'astigmatisme",
            "La presbytie",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "ophtho_glaucoma_001",
          prompt: "Le glaucome est causé par une augmentation de la pression ___ oculaire.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Réfraction et glaucome terminés",
          body: "Tu maîtrises maintenant les défauts de réfraction et le mécanisme du glaucome.",
          masteredConcepts: ["ophthalmology.refraction.myopia", "ophthalmology.glaucoma.iop"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates acute glaucoma clinical_case", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Urgences ophtalmologiques",
          body: "Glaucome aigu par fermeture de l'angle : douleur brutale, halos, nausées, œil rouge, cornée trouble, pupille en semi-mydriase fixe. OACR : baisse visuelle monoculaire brutale, tache rouge cerise.",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "ophtho_acute_glaucoma_cc_001",
          scenario:
            "Un homme de 65 ans se présente aux urgences avec une douleur oculaire droite intense d'installation brutale, des céphalées, des nausées, et voit des halos autour des lumières. L'œil est rouge, la cornée est trouble, et la pupille est en semi-mydriase fixe.",
          question: "Quel diagnostic ophtalmologique est le plus probable ?",
          options: [
            "Conjonctivite aiguë",
            "Kératite infectieuse",
            "Glaucome aigu par fermeture de l'angle",
            "Occlusion de l'artère centrale de la rétine",
          ] as [string, string, string, string],
          difficulty: "medium" as const,
          xpReward: 25,
        },
        {
          type: "complete" as const,
          title: "Urgences ophtalmologiques terminées",
          body: "Tu sais maintenant reconnaître les principales urgences ophtalmologiques.",
          masteredConcepts: ["ophthalmology.emergencies.acute_glaucoma"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();

    const key = {
      ophtho_acute_glaucoma_cc_001: {
        correctIndex: 2,
        explanation:
          "Le glaucome aigu par fermeture de l'angle se manifeste par une douleur oculaire intense et brutale, des halos colorés, des nausées, un œil rouge, une cornée œdématiée et une pupille en semi-mydriase aréactive.",
        conceptKey: "ophthalmology.emergencies.acute_glaucoma",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });
});
