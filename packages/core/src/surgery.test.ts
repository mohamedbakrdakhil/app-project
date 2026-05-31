import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Chirurgie générale lesson validation", () => {
  it("validates pre-op lesson schema (ASA fill_blank)", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Évaluation pré-opératoire",
          body: "Score ASA (I-VI), jeûne 6h solides / 2h liquides clairs, consentement éclairé.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "surg_fasting_001",
          question: "Durée de jeûne pour les liquides clairs avant une chirurgie ?",
          options: [
            "6 heures",
            "2 heures",
            "4 heures",
            "8 heures",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "surg_asa_001",
          prompt: "Le score ___ évalue le risque anesthésique du patient en 6 classes.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Évaluation pré-opératoire terminée",
          body: "Tu connais maintenant les éléments clés de l'évaluation pré-opératoire.",
          masteredConcepts: ["surgery.preop.asa_score"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();

    const key = {
      surg_asa_001: {
        acceptedAnswers: ["ASA"],
        explanation: "Le score ASA classe le risque anesthésique de I à VI.",
        conceptKey: "surgery.preop.asa_score",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates anesthesia recall schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Types d'anesthésie",
          body: "Générale : propofol/thiopental + isoflurane/TIVA + curarisation. Locorégionale : rachianesthésie, péridurale, bloc nerveux. Locale : lidocaïne/bupivacaïne.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "surg_induction_001",
          question: "Agent d'induction anesthésique le plus utilisé ?",
          options: [
            "Le propofol",
            "Le thiopental",
            "La kétamine",
            "L'isoflurane",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "surg_spinal_001",
          prompt:
            "L'anesthésie ___ consiste à injecter l'anesthésique dans l'espace sous-arachnoïdien.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Anesthésie terminée",
          body: "Tu connais maintenant les types d'anesthésie.",
          masteredConcepts: ["surgery.anesthesia.general"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();

    const key = {
      surg_induction_001: {
        correctIndex: 0,
        explanation: "Le propofol est l'agent d'induction le plus utilisé.",
        conceptKey: "surgery.anesthesia.general.induction.propofol",
        sourceRefs: [],
      },
      surg_spinal_001: {
        acceptedAnswers: ["rachidienne", "spinale", "rachianesthésie"],
        explanation: "La rachianesthésie injecte l'anesthésique dans l'espace sous-arachnoïdien.",
        conceptKey: "surgery.anesthesia.regional.spinal",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates post-op DVT clinical_case", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Soins post-opératoires",
          body: "Complications : saignement, ISO, TVP/EP (triade de Virchow), iléus. Prévention TVP : HBPM + bas de contention.",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "surg_dvt_cc_001",
          scenario:
            "Une femme de 45 ans, opérée d'une prothèse de hanche il y a 3 jours, présente une douleur et un œdème du mollet droit, rougeur et chaleur locale. La D-dimère est à 2500 ng/mL.",
          question: "Quel diagnostic post-opératoire doit être suspecté en priorité ?",
          options: [
            "Infection du site opératoire",
            "Thrombose veineuse profonde",
            "Hématome post-opératoire",
            "Syndrome compartimental",
          ] as [string, string, string, string],
          difficulty: "medium" as const,
          xpReward: 25,
        },
        {
          type: "recall" as const,
          questionKey: "surg_virchow_001",
          question: "Triade de Virchow pour le risque thromboembolique ?",
          options: [
            "Anémie, thrombopénie, coagulopathie",
            "Hypoxie, hypercapnie, acidose",
            "Stase, hypercoagulabilité, lésion endothéliale",
            "Immobilité, déshydratation, obésité",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "complete" as const,
          title: "Soins post-opératoires terminés",
          body: "Tu connais maintenant les complications post-opératoires.",
          masteredConcepts: ["surgery.postop.dvt"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });
});
