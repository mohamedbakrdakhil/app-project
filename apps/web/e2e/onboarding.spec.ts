import { test, expect } from "@playwright/test";

test.describe("Onboarding page", () => {
  test("onboarding page is accessible", async ({ page }) => {
    // Redirects to login since unauthenticated
    await page.goto("/onboarding");
    // Either shows login redirect or the onboarding page — just check no crash
    await expect(page).not.toHaveURL(/.*error/);
  });
});
