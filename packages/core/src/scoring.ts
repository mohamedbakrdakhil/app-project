export const XP_RULES = {
  correctAnswer: 15,
  incorrectAnswer: 0,
  perfectLessonBonus: 30,
  completionBonus: 20,
  fastAnswerBonus: 5,
} as const;

export type LessonScoreInput = {
  correctCount: number;
  totalRecallCount: number;
};

export type LessonScoreResult = {
  scorePercent: number;
  isCompleted: boolean;
  isPerfect: boolean;
  totalXp: number;
};

export function calculateLessonScore(input: LessonScoreInput): LessonScoreResult {
  const { correctCount, totalRecallCount } = input;
  if (totalRecallCount === 0) {
    return { scorePercent: 100, isCompleted: true, isPerfect: true, totalXp: XP_RULES.completionBonus };
  }
  const scorePercent = Math.round((correctCount / totalRecallCount) * 100);
  const isCompleted = scorePercent >= 60;
  const isPerfect = scorePercent === 100;
  const baseXp = correctCount * XP_RULES.correctAnswer;
  const bonus = isPerfect ? XP_RULES.perfectLessonBonus : 0;
  const completionBonus = isCompleted ? XP_RULES.completionBonus : 0;
  return {
    scorePercent,
    isCompleted,
    isPerfect,
    totalXp: baseXp + bonus + completionBonus,
  };
}
