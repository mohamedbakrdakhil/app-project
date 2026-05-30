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
});
