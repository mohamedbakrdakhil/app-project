import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Neurology lesson validation", () => {
  it("validates action potential recall step", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Le potentiel d'action",
          body: "Le potentiel de repos est de -70 mV. Lors de la dépolarisation, les ions Na+ entrent dans la cellule.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "ap_ion_001",
          question: "Quel ion entre principalement lors de la dépolarisation ?",
          options: ["Sodium (Na+)", "Potassium (K+)", "Calcium (Ca2+)", "Chlorure (Cl-)"] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "ap_resting_001",
          prompt: "Le potentiel de repos d'une cellule nerveuse est d'environ ___ mV.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Potentiel d'action terminé",
          body: "Tu connais maintenant les bases du potentiel d'action.",
          masteredConcepts: ["neurology.action_potential.ions"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates synapse lesson with clinical_case step", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "La synapse",
          body: "La synapse comprend le terminal présynaptique, la fente synaptique et le récepteur postsynaptique. Les neurotransmetteurs incluent ACh, dopamine, sérotonine et GABA.",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "synapse_benzo_001",
          scenario:
            "Un patient de 25 ans est traité par benzodiazépines pour un trouble anxieux. Ces médicaments potentialisent l'action du GABA sur les récepteurs GABA-A.",
          question: "Quel est l'effet attendu sur l'activité neuronale ?",
          options: [
            "Augmentation de l'excitabilité neuronale",
            "Diminution de l'excitabilité neuronale",
            "Aucun effet sur l'excitabilité",
            "Augmentation de la libération de dopamine",
          ] as [string, string, string, string],
          xpReward: 25,
          difficulty: "easy" as const,
        },
        {
          type: "complete" as const,
          title: "Synapse terminée",
          body: "Tu connais maintenant les bases de la neurotransmission.",
          masteredConcepts: ["neurology.synapse.neurotransmitters"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates fill_blank answer key for neurology", () => {
    const key = {
      ap_resting_001: {
        acceptedAnswers: ["-70"],
        explanation: "Le potentiel de repos d'une cellule nerveuse au repos est d'environ -70 mV.",
        conceptKey: "neurology.action_potential.resting_potential",
        sourceRefs: [],
      },
      ap_ion_001: {
        correctIndex: 0,
        explanation: "Lors de la dépolarisation, les canaux Na+ voltage-dépendants s'ouvrent, laissant entrer massivement le sodium.",
        conceptKey: "neurology.action_potential.depolarization",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });
});
