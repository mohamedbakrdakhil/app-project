export type ProgressSummary = {
  totalLevels: number;
  completedLevels: number;
  percentComplete: number;
};

export function computeProgressSummary(
  totalLevels: number,
  completedLevelIds: string[],
): ProgressSummary {
  const completedLevels = completedLevelIds.length;
  const percentComplete = totalLevels > 0 ? Math.round((completedLevels / totalLevels) * 100) : 0;
  return { totalLevels, completedLevels, percentComplete };
}
