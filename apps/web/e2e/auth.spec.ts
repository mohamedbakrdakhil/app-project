import { test, expect } from "@playwright/test";

test.describe("Auth flow", () => {
  test("login page renders", async ({ page }) => {
    await page.goto("/login");
    await expect(page.getByText("Masteri")).toBeVisible();
    await expect(page.getByRole("button", { name: /se connecter/i })).toBeVisible();
  });

  test("register page renders", async ({ page }) => {
    await page.goto("/register");
    await expect(page.getByText("Masteri")).toBeVisible();
    await expect(page.getByRole("button", { name: /créer mon compte/i })).toBeVisible();
  });

  test("unauthenticated user is redirected to login", async ({ page }) => {
    await page.goto("/home");
    await expect(page).toHaveURL(/.*login/);
  });
});
