import { test, expect } from "@playwright/test";

test.describe("Navigation", () => {
  test("login page has register link", async ({ page }) => {
    await page.goto("/login");
    const link = page.getByRole("link", { name: /s'inscrire/i });
    await expect(link).toBeVisible();
    await link.click();
    await expect(page).toHaveURL(/.*register/);
  });

  test("register page has login link", async ({ page }) => {
    await page.goto("/register");
    const link = page.getByRole("link", { name: /se connecter/i });
    await expect(link).toBeVisible();
    await link.click();
    await expect(page).toHaveURL(/.*login/);
  });

  test("protected routes redirect to login when unauthenticated", async ({ page }) => {
    for (const path of ["/home", "/reviews", "/profile"]) {
      await page.goto(path);
      await expect(page).toHaveURL(/.*login/);
    }
  });
});
