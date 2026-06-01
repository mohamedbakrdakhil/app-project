import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Cardiology 2 lesson validation", () => {
  it("validates heart failure lesson schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Insuffisance cardiaque",
          body: "IC systolique : FE < 40%. IC diastolique : FE préservée. IC gauche → dyspnée, crépitants. IC droite → œdèmes, hépatomégalie. NYHA I-IV.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "card_hf_left_001",
          question: "Signe caractéristique de l'insuffisance cardiaque gauche ?",
          options: [
            "Les œdèmes des membres inférieurs",
            "La dyspnée et les crépitants pulmonaires",
            "La turgescence jugulaire",
            "L'hépatomégalie",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "complete" as const,
          title: "Insuffisance cardiaque terminée",
          body: "Tu connais maintenant la physiopathologie de l'insuffisance cardiaque.",
          masteredConcepts: ["physiology.heart_failure.systolic_diastolic"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates ACS fill_blank answer key (ST segment)", () => {
    const key = {
      card_acs_ecg_001: {
        acceptedAnswers: ["ST"],
        explanation:
          "Le STEMI se caractérise par un sus-décalage du segment ST ≥ 1 mm dans au moins 2 dérivations contiguës.",
        conceptKey: "physiology.acs.stemi_ecg",
        sourceRefs: [],
      },
      card_acs_delay_001: {
        correctIndex: 2,
        explanation:
          "Le délai porte-ballon recommandé pour l'angioplastie primaire dans le STEMI est de 120 minutes maximum.",
        conceptKey: "physiology.acs.primary_pci",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates AF anticoagulation clinical_case step schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Arythmies cardiaques",
          body: "FA : arythmie soutenue la plus fréquente, risque AVC, anticoagulation selon CHA₂DS₂-VASc. FV : arrêt cardiaque → défibrillation.",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "card_arrhythmias_af_001",
          scenario:
            "Un patient de 72 ans diabétique et hypertendu présente depuis 2 jours une fibrillation auriculaire à 110/min. Le score CHA₂DS₂-VASc est à 4. Il n'a pas d'antécédent hémorragique.",
          question: "Quelle est l'indication thérapeutique prioritaire chez ce patient ?",
          options: [
            "Cardioversion électrique immédiate",
            "Anticoagulation orale pour prévenir les accidents thromboemboliques",
            "Arrêt de tout traitement et surveillance",
            "Implantation d'un pacemaker",
          ] as [string, string, string, string],
          difficulty: "medium" as const,
          xpReward: 25,
        },
        {
          type: "complete" as const,
          title: "Arythmies terminées",
          body: "Tu connais maintenant la prise en charge de la fibrillation auriculaire.",
          masteredConcepts: ["physiology.arrhythmias.atrial_fibrillation"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });
});
