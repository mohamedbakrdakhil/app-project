import { test, expect } from "@playwright/test";

test.describe("API routes (unauthenticated)", () => {
  test("lesson/start returns 401 without auth", async ({ request }) => {
    const res = await request.post("/api/lesson/start", {
      data: { levelId: "00000000-0000-0000-0000-000000000000" },
    });
    expect(res.status()).toBe(401);
  });

  test("lesson/answer returns 401 without auth", async ({ request }) => {
    const res = await request.post("/api/lesson/answer", {
      data: { attemptId: "00000000-0000-0000-0000-000000000000", stepIndex: 0, questionKey: "test", selectedIndex: 0 },
    });
    expect(res.status()).toBe(401);
  });

  test("lesson/complete returns 401 without auth", async ({ request }) => {
    const res = await request.post("/api/lesson/complete", {
      data: { attemptId: "00000000-0000-0000-0000-000000000000" },
    });
    expect(res.status()).toBe(401);
  });

  test("reviews/due returns 401 without auth", async ({ request }) => {
    const res = await request.get("/api/reviews/due");
    expect(res.status()).toBe(401);
  });

  test("analytics/errors returns 401 without auth", async ({ request }) => {
    const res = await request.get("/api/analytics/errors");
    expect(res.status()).toBe(401);
  });

  test("admin/ai/generate returns 401 without auth", async ({ request }) => {
    const res = await request.post("/api/admin/ai/generate", {
      data: { subjectId: "anatomy", chapterId: "00000000-0000-0000-0000-000000000000", concept: "test" },
    });
    expect(res.status()).toBe(401);
  });

  test("admin/ai/drafts returns 401 without auth", async ({ request }) => {
    const res = await request.get("/api/admin/ai/drafts");
    expect(res.status()).toBe(401);
  });

  test("profile/goal returns 401 without auth", async ({ request }) => {
    const res = await request.put("/api/profile/goal", { data: { dailyGoal: 5 } });
    expect(res.status()).toBe(401);
  });

  test("league returns 401 without auth", async ({ request }) => {
    const res = await request.get("/api/league");
    expect(res.status()).toBe(401);
  });

  test("notifications returns 401 without auth", async ({ request }) => {
    const res = await request.get("/api/notifications");
    expect(res.status()).toBe(401);
  });

  test("search returns 401 without auth", async ({ request }) => {
    const res = await request.get("/api/search?q=fémur");
    expect(res.status()).toBe(401);
  });

  test("notifications/read returns 401 without auth", async ({ request }) => {
    const res = await request.post("/api/notifications/read", {
      data: { notificationIds: ["00000000-0000-0000-0000-000000000000"] },
    });
    expect(res.status()).toBe(401);
  });

  test("reviews/due with subject filter returns 401 without auth", async ({ request }) => {
    const res = await request.get("/api/reviews/due?subject=anatomy");
    expect(res.status()).toBe(401);
  });

  test("reviews/submit returns 401 without auth", async ({ request }) => {
    const res = await request.post("/api/reviews/submit", {
      data: { cardId: "00000000-0000-0000-0000-000000000000", quality: 3 },
    });
    expect(res.status()).toBe(401);
  });

  test("onboarding/complete returns 401 without auth", async ({ request }) => {
    const res = await request.post("/api/onboarding/complete", {
      data: { dailyGoal: 5, preferredSubjects: [] },
    });
    expect(res.status()).toBe(401);
  });
});
