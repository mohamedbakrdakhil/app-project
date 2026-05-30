export type BadgeConditionType =
  | "first_level_complete"
  | "perfect_score"
  | "streak_days"
  | "total_xp"
  | "levels_complete_count";

export type BadgeDef = {
  id: string;
  condition_type: BadgeConditionType;
  condition_value: number;
};

export type UserStats = {
  levelsCompleted: number;
  hasPerfectScore: boolean;
  streakDays: number;
  totalXp: number;
};

export function evaluateBadges(badges: BadgeDef[], stats: UserStats, alreadyEarned: string[]): string[] {
  const earned = new Set(alreadyEarned);
  const newBadges: string[] = [];

  for (const badge of badges) {
    if (earned.has(badge.id)) continue;
    let qualifies = false;
    switch (badge.condition_type) {
      case "first_level_complete":
        qualifies = stats.levelsCompleted >= badge.condition_value;
        break;
      case "perfect_score":
        qualifies = stats.hasPerfectScore;
        break;
      case "streak_days":
        qualifies = stats.streakDays >= badge.condition_value;
        break;
      case "total_xp":
        qualifies = stats.totalXp >= badge.condition_value;
        break;
      case "levels_complete_count":
        qualifies = stats.levelsCompleted >= badge.condition_value;
        break;
    }
    if (qualifies) newBadges.push(badge.id);
  }
  return newBadges;
}
