import { z } from "zod";

export const SourceRefSchema = z.object({
  title: z.string().min(1),
  type: z.enum(["open_educational", "textbook_reference", "institutional", "internal_review"]),
  edition: z.string().optional(),
  chapter: z.string().optional(),
  url: z.string().url().optional(),
  note: z.string().optional(),
});

export const IntroStepSchema = z.object({
  type: z.literal("intro"),
  title: z.string().min(1),
  subtitle: z.string().optional(),
  body: z.string().min(1),
  fact: z.string().optional(),
  visual: z
    .object({
      type: z.enum(["image", "svg", "placeholder", "3d_model"]),
      src: z.string().optional(),
      alt: z.string().optional(),
      caption: z.string().optional(),
    })
    .optional(),
  sourceRefs: z.array(SourceRefSchema).default([]),
});

export const RecallStepSchema = z.object({
  type: z.literal("recall"),
  questionKey: z.string().min(1),
  question: z.string().min(1),
  options: z.tuple([z.string(), z.string(), z.string(), z.string()]),
  timerSeconds: z.number().int().positive().optional(),
  xpReward: z.number().int().nonnegative().default(15),
});

export const CompleteStepSchema = z.object({
  type: z.literal("complete"),
  title: z.string().min(1),
  body: z.string().min(1),
  masteredConcepts: z.array(z.string()).default([]),
});

export const LessonStepSchema = z.discriminatedUnion("type", [
  IntroStepSchema,
  RecallStepSchema,
  CompleteStepSchema,
]);

export const LessonContentPublicSchema = z.object({
  schemaVersion: z.literal(1),
  locale: z.literal("fr"),
  estimatedMinutes: z.number().int().positive(),
  steps: z.array(LessonStepSchema).min(1),
  disclaimer: z.string().default("Contenu éducatif. Ne remplace pas un avis médical."),
});

export const AnswerEntrySchema = z.object({
  correctIndex: z.number().int().min(0).max(3),
  explanation: z.string().min(1),
  conceptKey: z.string().min(1),
  sourceRefs: z.array(SourceRefSchema).default([]),
});

export const LevelAnswerKeySchema = z.record(z.string(), AnswerEntrySchema);

export type SourceRef = z.infer<typeof SourceRefSchema>;
export type LessonContentPublic = z.infer<typeof LessonContentPublicSchema>;
export type LevelAnswerKey = z.infer<typeof LevelAnswerKeySchema>;
export type LessonStep = z.infer<typeof LessonStepSchema>;
export type IntroStep = z.infer<typeof IntroStepSchema>;
export type RecallStep = z.infer<typeof RecallStepSchema>;
export type CompleteStep = z.infer<typeof CompleteStepSchema>;
