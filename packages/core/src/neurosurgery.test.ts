import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Neurochirurgie lesson validation", () => {
  it("validates stroke lesson schema (4h30 recall)", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Accident vasculaire cérébral",
          body: "AVC ischémique (85%) : occlusion artérielle → thrombolyse/thrombectomie. Fenêtre thrombolyse : 4h30 depuis le début des symptômes.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "nsurg_stroke_thrombo_001",
          question: "Délai maximal pour la thrombolyse intraveineuse dans l'AVC ischémique ?",
          options: [
            "3 heures",
            "4h30 (4 heures 30 minutes)",
            "6 heures",
            "12 heures",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "nsurg_stroke_fast_001",
          prompt: "L'acronyme ___ aide le grand public à reconnaître les symptômes d'un AVC.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "AVC terminé",
          body: "Tu connais maintenant les types d'AVC, l'acronyme FAST et les fenêtres thérapeutiques.",
          masteredConcepts: ["neurosurgery.stroke.ischemic", "neurosurgery.stroke.fast"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();

    const key = {
      nsurg_stroke_thrombo_001: {
        correctIndex: 1,
        explanation: "La fenêtre thérapeutique pour la thrombolyse intraveineuse par rt-PA est de 4h30 depuis le début des symptômes.",
        conceptKey: "neurosurgery.stroke.thrombolysis_window",
        sourceRefs: [],
      },
      nsurg_stroke_fast_001: {
        acceptedAnswers: ["FAST"],
        explanation: "L'acronyme FAST aide à reconnaître les signes d'un AVC.",
        conceptKey: "neurosurgery.stroke.fast",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates trauma fill_blank (15 points GCS)", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Traumatisme crânio-encéphalique",
          body: "TCE léger (GCS 13-15), modéré (GCS 9-12), sévère (GCS ≤ 8). Score de Glasgow : Yeux 1-4, Verbal 1-5, Moteur 1-6, max 15.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "nsurg_trauma_art_001",
          question: "Artère lésée dans l'hématome extradural ?",
          options: [
            "L'artère cérébrale moyenne",
            "L'artère vertébrale",
            "L'artère méningée moyenne",
            "L'artère communicante postérieure",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "nsurg_trauma_gcs_001",
          prompt: "Le score de Glasgow est côté de 3 à ___ points.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Traumatisme crânien terminé",
          body: "Tu connais maintenant la classification des TCE, le score de Glasgow et les hématomes intracrâniens.",
          masteredConcepts: ["neurosurgery.trauma.gcs", "neurosurgery.trauma.hematoma"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();

    const key = {
      nsurg_trauma_art_001: {
        correctIndex: 2,
        explanation: "L'hématome extradural résulte le plus souvent d'une rupture de l'artère méningée moyenne.",
        conceptKey: "neurosurgery.trauma.epidural_hematoma",
        sourceRefs: [],
      },
      nsurg_trauma_gcs_001: {
        acceptedAnswers: ["15", "quinze"],
        explanation: "Le score de Glasgow est coté de 3 à 15 points.",
        conceptKey: "neurosurgery.trauma.gcs",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });

  it("validates Cushing triad clinical_case", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 6,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Hypertension intracrânienne",
          body: "HTIC : pression normale < 15 mmHg. Triade de Cushing : hypertension artérielle + bradycardie + troubles respiratoires (signe terminal d'engagement).",
          sourceRefs: [],
        },
        {
          type: "clinical_case" as const,
          questionKey: "nsurg_icp_cc_001",
          scenario:
            "Un homme de 40 ans est admis après un AVP. GCS 7. Pupille droite fixe et dilatée. PA 200/110 mmHg, FC 48/min, respiration irrégulière. Le scanner montre une collection lenticulaire temporale droite avec déviation de la ligne médiane de 12 mm.",
          question: "Quelle triade clinique signe l'engagement cérébral imminent ?",
          options: [
            "Fièvre + céphalées + photophobie",
            "HTA + bradycardie + troubles respiratoires",
            "Mydriase + hémiparésie + aphasie",
            "Hypotension + tachycardie + confusion",
          ] as [string, string, string, string],
          difficulty: "hard" as const,
          xpReward: 25,
        },
        {
          type: "recall" as const,
          questionKey: "nsurg_icp_osmotherapy_001",
          question: "Traitement osmotique de première intention de l'HTIC ?",
          options: [
            "Le mannitol à 20%",
            "Le furosémide IV",
            "Le sérum physiologique",
            "Le dexaméthasone",
          ] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "complete" as const,
          title: "HTIC terminée",
          body: "Tu connais maintenant les signes de l'HTIC, la triade de Cushing et les traitements d'urgence.",
          masteredConcepts: ["neurosurgery.icp.cushing_triad", "neurosurgery.icp.treatment"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });
});
