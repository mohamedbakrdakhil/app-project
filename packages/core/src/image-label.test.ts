import { describe, it, expect } from "vitest";
import { ImageLabelStepSchema, LessonContentPublicSchema } from "./lesson-schema";

describe("ImageLabelStep schema", () => {
  it("accepts valid image_label step", () => {
    const step = {
      type: "image_label" as const,
      title: "Le cœur",
      imageAlt: "Schéma du cœur",
      labels: [
        { id: "l1", text: "Oreillette gauche", position: { x: 30, y: 40 } },
      ],
      sourceRefs: [],
    };
    expect(() => ImageLabelStepSchema.parse(step)).not.toThrow();
  });

  it("rejects step with empty labels array", () => {
    expect(() => ImageLabelStepSchema.parse({
      type: "image_label",
      title: "Test",
      imageAlt: "test",
      labels: [],
      sourceRefs: [],
    })).toThrow();
  });

  it("rejects label with out-of-range position", () => {
    expect(() => ImageLabelStepSchema.parse({
      type: "image_label",
      title: "Test",
      imageAlt: "test",
      labels: [{ id: "l1", text: "Zone", position: { x: 150, y: 50 } }],
      sourceRefs: [],
    })).toThrow();
  });

  it("accepts lesson with image_label step", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 5,
      disclaimer: "Contenu éducatif.",
      steps: [
        {
          type: "image_label" as const,
          title: "Schéma",
          imageAlt: "alt",
          labels: [{ id: "a", text: "Zone A", position: { x: 50, y: 50 } }],
          sourceRefs: [],
        },
        { type: "complete" as const, title: "Terminé", body: "Bien joué", masteredConcepts: [] },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });
});
