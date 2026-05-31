import { describe, it, expect } from "vitest";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "./lesson-schema";

describe("Anatomy — Peripheral Nervous System lesson validation", () => {
  it("validates cranial nerves lesson schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 4,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Les nerfs crâniens",
          body: "Il existe 12 paires de nerfs crâniens. Parmi les plus importants : I olfactif, II optique, III oculomoteur, V trijumeau, VII facial, X vague. Ils peuvent être sensitifs, moteurs ou mixtes.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "cn_vagus_001",
          question: "Quel est le numéro du nerf vague ?",
          options: ["V (cinq)", "VII (sept)", "IX (neuf)", "X (dix)"] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "cn_count_001",
          prompt: "Les nerfs crâniens sont au nombre de ___ paires.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Nerfs crâniens terminés",
          body: "Tu connais maintenant les principaux nerfs crâniens.",
          masteredConcepts: ["anatomy.pns.cranial_nerves"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates spinal nerves lesson schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 4,
      disclaimer: "Contenu éducatif. Ne remplace pas un avis médical.",
      steps: [
        {
          type: "intro" as const,
          title: "Les nerfs spinaux",
          body: "Il existe 31 paires de nerfs spinaux : 8 cervicaux, 12 thoraciques, 5 lombaires, 5 sacraux, 1 coccygien. La racine dorsale est sensitive, la racine ventrale est motrice.",
          sourceRefs: [],
        },
        {
          type: "recall" as const,
          questionKey: "sn_count_001",
          question: "Combien y a-t-il de paires de nerfs spinaux ?",
          options: ["28 paires", "31 paires", "33 paires", "36 paires"] as [string, string, string, string],
          xpReward: 15,
        },
        {
          type: "fill_blank" as const,
          questionKey: "sn_ventral_001",
          prompt: "La racine ___ du nerf spinal est motrice.",
          xpReward: 10,
        },
        {
          type: "complete" as const,
          title: "Nerfs spinaux terminés",
          body: "Tu connais maintenant l'organisation des nerfs spinaux.",
          masteredConcepts: ["anatomy.pns.spinal_nerves"],
        },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });

  it("validates autonomic nervous system answer key", () => {
    const key = {
      sn_count_001: {
        correctIndex: 1,
        explanation: "Il existe 31 paires de nerfs spinaux : 8 cervicales, 12 thoraciques, 5 lombaires, 5 sacrales et 1 coccygienne.",
        conceptKey: "anatomy.pns.spinal_nerves.count",
        sourceRefs: [],
      },
      sn_ventral_001: {
        acceptedAnswers: ["ventrale", "antérieure"],
        explanation: "La racine ventrale (antérieure) du nerf spinal est motrice, tandis que la racine dorsale (postérieure) est sensitive.",
        conceptKey: "anatomy.pns.spinal_nerves.roots",
        sourceRefs: [],
      },
      ans_nt_001: {
        correctIndex: 2,
        explanation: "Le système nerveux sympathique utilise la noradrénaline comme neurotransmetteur principal au niveau des organes effecteurs.",
        conceptKey: "anatomy.pns.autonomic.sympathetic_nt",
        sourceRefs: [],
      },
    };
    expect(() => LevelAnswerKeySchema.parse(key)).not.toThrow();
  });
});
