import Anthropic from "@anthropic-ai/sdk";
import { LessonContentPublicSchema, LevelAnswerKeySchema } from "@masteri/core";

const anthropic = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY,
});

export type GenerateInput = {
  subject: string;
  chapter: string;
  concept: string;
  level: "easy" | "medium" | "hard";
  locale: "fr";
};

export type GenerateResult = {
  contentPublic: unknown;
  answerKey: unknown;
  modelUsed: string;
};

const SYSTEM_PROMPT = [
  "Tu es un professeur de sciences médicales qui crée du contenu pédagogique original en français.",
  "Tu produis UNIQUEMENT du contenu éducatif original — tu ne copies pas de textes protégés.",
  "Tu n'inventes JAMAIS de page, édition ou citation bibliographique précise.",
  "Tu réponds UNIQUEMENT en JSON valide, sans texte autour.",
  "Le contenu est destiné à des étudiants en médecine/santé.",
  "Ajoute toujours le disclaimer 'Contenu éducatif. Ne remplace pas un avis médical.'",
].join("\n");

const USER_TEMPLATE = (input: GenerateInput) => `
Génère une leçon courte sur le concept suivant :
- Matière : ${input.subject}
- Chapitre : ${input.chapter}
- Concept : ${input.concept}
- Difficulté : ${input.level}

Retourne un JSON avec exactement cette structure :
{
  "contentPublic": {
    "schemaVersion": 1,
    "locale": "fr",
    "estimatedMinutes": 4,
    "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
    "steps": [
      {
        "type": "intro",
        "title": "...",
        "subtitle": "...",
        "body": "... (2-3 phrases pédagogiques originales)",
        "fact": "... (un fait intéressant)",
        "visual": { "type": "placeholder", "alt": "..." },
        "sourceRefs": [{ "title": "Open educational references", "type": "open_educational", "note": "Contenu original" }]
      },
      {
        "type": "recall",
        "questionKey": "..._001",
        "question": "...",
        "options": ["option A", "option B", "option C", "option D"],
        "timerSeconds": 45,
        "xpReward": 15
      },
      {
        "type": "recall",
        "questionKey": "..._002",
        "question": "...",
        "options": ["option A", "option B", "option C", "option D"],
        "timerSeconds": 45,
        "xpReward": 15
      },
      {
        "type": "complete",
        "title": "... terminé",
        "body": "Tu maîtrises maintenant ...",
        "masteredConcepts": ["${input.subject.toLowerCase()}.${input.chapter.toLowerCase().replace(/\s/g,"_")}.${input.concept.toLowerCase().replace(/\s/g,"_")}"]
      }
    ]
  },
  "answerKey": {
    "..._001": {
      "correctIndex": 0,
      "explanation": "...",
      "conceptKey": "...",
      "sourceRefs": [{ "title": "Open educational references", "type": "open_educational" }]
    },
    "..._002": {
      "correctIndex": 0,
      "explanation": "...",
      "conceptKey": "...",
      "sourceRefs": [{ "title": "Open educational references", "type": "open_educational" }]
    }
  }
}

IMPORTANT: La bonne réponse doit être à l'index 0 dans chaque question, et les autres options doivent être des distracteurs plausibles mais incorrects.
`;

export async function generateLessonDraft(input: GenerateInput): Promise<GenerateResult> {
  const model = process.env.ANTHROPIC_MODEL ?? "claude-sonnet-4-6";

  const response = await anthropic.messages.create({
    model,
    max_tokens: 2000,
    system: SYSTEM_PROMPT,
    messages: [{ role: "user", content: USER_TEMPLATE(input) }],
  });

  const textBlocks = response.content.filter((b): b is Anthropic.TextBlock => b.type === "text");
  const text = textBlocks.map((b) => b.text).join("");

  // Strip markdown code fences if present
  const cleaned = text.replace(/^```json\s*/i, "").replace(/```\s*$/, "").trim();
  const parsed = JSON.parse(cleaned) as { contentPublic: unknown; answerKey: unknown };

  // Validate schemas
  LessonContentPublicSchema.parse(parsed.contentPublic);
  LevelAnswerKeySchema.parse(parsed.answerKey);

  return {
    contentPublic: parsed.contentPublic,
    answerKey: parsed.answerKey,
    modelUsed: model,
  };
}
