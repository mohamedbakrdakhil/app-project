import { test, expect } from "@playwright/test";
import { LessonContentPublicSchema } from "@masteri/core";

test.describe("Lesson schema validation (unit-style via Playwright)", () => {
  test("valid lesson passes schema", () => {
    const lesson = {
      schemaVersion: 1 as const,
      locale: "fr" as const,
      estimatedMinutes: 4,
      disclaimer: "Contenu éducatif.",
      steps: [
        { type: "intro" as const, title: "Test", body: "Body text", sourceRefs: [] },
        { type: "complete" as const, title: "Done", body: "Finished", masteredConcepts: [] },
      ],
    };
    expect(() => LessonContentPublicSchema.parse(lesson)).not.toThrow();
  });
});
