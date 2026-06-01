import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Rhumatologie lesson validation", () => {
  it("validates osteoarthritis cartilage fill_blank", () => {
    const key = {
      rheum_oa_cartilage_001: {
        acceptedAnswers: ["cartilage"],
        explanation:
          "L'arthrose est une maladie dégénérative caractérisée par la destruction progressive du cartilage articulaire.",
        conceptKey: "rheumatology.osteoarthritis.cartilage",
        sourceRefs: [],
      },
      rheum_oa_pain_001: {
        correctIndex: 0,
        explanation:
          "La douleur arthrosique est de type mécanique : aggravée à l'effort, soulagée au repos.",
        conceptKey: "rheumatology.osteoarthritis.mechanical_pain",
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
          title: "Arthrose",
          body: "L'arthrose est une maladie dégénérative du cartilage articulaire. Douleur mécanique (aggravée à l'effort, soulagée au repos). Raideur matinale < 30 min.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "rheum_oa_pain_001",
          question: "Caractère de la douleur dans l'arthrose ?",
          options: [
            "Mécanique (aggravée à l'effort, soulagée au repos)",
            "Inflammatoire (prédominance nocturne, raideur matinale > 1h)",
            "Neuropathique (brûlures, paresthésies)",
            "Vasculaire (claudication intermittente)",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "rheum_oa_cartilage_001",
          prompt: "L'arthrose se caractérise par une destruction du ___.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Arthrose terminée",
          body: "Tu connais maintenant les caractéristiques de l'arthrose.",
          masteredConcepts: ["rheumatology.osteoarthritis.cartilage"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates RA anti-CCP recall", () => {
    const key = {
      rheum_ra_anticcp_001: {
        correctIndex: 2,
        explanation:
          "Les anticorps anti-CCP sont les plus spécifiques de la polyarthrite rhumatoïde (spécificité ~96%).",
        conceptKey: "rheumatology.ra.anti_ccp",
        sourceRefs: [],
      },
      rheum_ra_inflammatory_001: {
        acceptedAnswers: ["inflammatoire"],
        explanation:
          "La douleur de la PR est de caractère inflammatoire : prédominance nocturne et matinale, raideur matinale > 1h.",
        conceptKey: "rheumatology.ra.inflammatory_pain",
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
          title: "Polyarthrite rhumatoïde",
          body: "La PR est une maladie auto-immune touchant la synoviale. Atteinte bilatérale symétrique des petites articulations. Raideur matinale > 1h. Anti-CCP très spécifiques. Traitement : méthotrexate en première ligne.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "rheum_ra_anticcp_001",
          question: "Anticorps le plus spécifique de la polyarthrite rhumatoïde ?",
          options: [
            "Anticorps anti-nucléaires (ANA)",
            "Facteur rhumatoïde (FR)",
            "Anti-CCP (anti-peptides citrullinés cycliques)",
            "Anticorps anti-ADN natif",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "rheum_ra_inflammatory_001",
          prompt: "La douleur de la polyarthrite rhumatoïde est de caractère ___ (plus intense le matin).",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Polyarthrite rhumatoïde terminée",
          body: "Tu connais maintenant les critères diagnostiques de la polyarthrite rhumatoïde.",
          masteredConcepts: ["rheumatology.ra.anti_ccp"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates ankylosing spondylitis clinical_case", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Spondylarthrites",
          body: "Les spondylarthropathies sont associées à HLA-B27. La spondylarthrite ankylosante : sacro-iléite, colonne en bambou. Douleur lombaire inflammatoire : < 45 ans, insidieuse, améliorée à l'exercice.",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "rheum_spondylo_cc_001",
          scenario:
            "Un homme de 28 ans consulte pour des douleurs lombaires évoluant depuis 6 mois, prédominant la nuit et le matin avec une raideur matinale de 2 heures, s'améliorant à l'activité physique. La sacro-iléite est visible à l'IRM. HLA-B27 positif.",
          question: "Quel diagnostic correspond à ce tableau ?",
          options: [
            "Hernie discale L4-L5",
            "Spondylarthrite ankylosante",
            "Arthrose lombaire",
            "Fibromyalgie",
          ] as [string, string, string, string],
          difficulty: "medium" as const,
          xpReward: 25,
        },
        {
          type: "recall" as const,
          questionKey: "rheum_hlab27_001",
          question: "Gène HLA associé aux spondylarthropathies ?",
          options: [
            "HLA-B27",
            "HLA-DR4",
            "HLA-B51",
            "HLA-DQ2",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "complete" as const,
          title: "Spondylarthrites terminées",
          body: "Tu connais maintenant les caractéristiques des spondylarthropathies.",
          masteredConcepts: ["rheumatology.spondylo.hla_b27", "rheumatology.spondylo.ankylosing_spondylitis"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();

    const key = {
      rheum_spondylo_cc_001: {
        correctIndex: 1,
        explanation:
          "Le tableau de douleurs lombaires inflammatoires, sacro-iléite à l'IRM et HLA-B27 positif chez un homme jeune est caractéristique de la spondylarthrite ankylosante.",
        conceptKey: "rheumatology.spondylo.ankylosing_spondylitis",
        sourceRefs: [],
      },
      rheum_hlab27_001: {
        correctIndex: 0,
        explanation:
          "HLA-B27 est l'antigène d'histocompatibilité associé aux spondylarthropathies, présent chez ~90% des patients atteints de spondylarthrite ankylosante.",
        conceptKey: "rheumatology.spondylo.hla_b27",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });
});
