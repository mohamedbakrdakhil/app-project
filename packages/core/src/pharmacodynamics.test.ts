import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Pharmacodynamics lesson validation", () => {
  it("validates receptor lesson schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 4,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Les récepteurs pharmacologiques",
          body: "Agoniste (active), antagoniste (bloque), agoniste partiel. Affinité vs efficacité. Courbe dose-réponse. EC50 = concentration donnant 50 % de l'effet maximal.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "pd_antag_001",
          question: "Comment agit un antagoniste ?",
          options: [
            "Il bloque le récepteur sans l'activer",
            "Il active le récepteur avec un effet maximal",
            "Il active le récepteur partiellement",
            "Il détruit le récepteur",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "pd_ec50_001",
          prompt: "L'EC50 est la concentration d'un médicament produisant ___ % de l'effet maximal.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Récepteurs pharmacologiques terminés",
          body: "Tu connais maintenant les notions d'agonisme, d'antagonisme et de courbe dose-réponse.",
          masteredConcepts: ["pharmacology.pd.agonist", "pharmacology.pd.antagonist"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates dose-effect fill_blank answer key", () => {
    const key = {
      pd_ti_001: {
        correctIndex: 2,
        explanation: "L'index thérapeutique = DL50 / DE50.",
        conceptKey: "pharmacology.pd.therapeutic_index.formula",
        sourceRefs: [],
      },
      pd_narrow_ti_001: {
        acceptedAnswers: ["étroit", "faible"],
        explanation: "Un médicament à index thérapeutique étroit nécessite une surveillance étroite.",
        conceptKey: "pharmacology.pd.narrow_therapeutic_index",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates targets clinical_case lesson schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Cibles thérapeutiques",
          body: "4 cibles principales : récepteurs, enzymes (IEC, statines), canaux ioniques (inhibiteurs calciques, anesthésiques locaux), transporteurs (ISRS).",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "pd_amlod_cc_001",
          scenario:
            "Un patient hypertendu est traité par amlodipine, un inhibiteur des canaux calciques. Après 2 semaines, sa pression artérielle passe de 160/95 à 130/80 mmHg. Il présente des œdèmes des chevilles.",
          question: "Quel est le mécanisme d'action de l'amlodipine ?",
          options: [
            "Inhibition de l'enzyme de conversion",
            "Blocage des récepteurs bêta-adrénergiques",
            "Blocage des canaux calciques voltage-dépendants",
            "Inhibition de la pompe Na+/K+-ATPase",
          ] as [string, string, string, string],
          difficulty: "medium" as const,
          xpReward: 25,
        },
        {
          type: "recall" as const,
          questionKey: "pd_ssri_001",
          question: "Les ISRS agissent sur :",
          options: [
            "Le récepteur sérotoninergique 5-HT2",
            "Le transporteur de recapture de la sérotonine",
            "La monoamine oxydase",
            "Le récepteur dopaminergique D2",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "complete" as const,
          title: "Cibles thérapeutiques terminées",
          body: "Tu connais maintenant les 4 grandes classes de cibles thérapeutiques.",
          masteredConcepts: ["pharmacology.pd.targets.receptors", "pharmacology.pd.targets.enzymes"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });
});
