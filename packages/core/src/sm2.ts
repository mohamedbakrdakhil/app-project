export type Sm2Input = {
  quality: 0 | 1 | 2 | 3 | 4 | 5;
  repetitions: number;
  intervalDays: number;
  easeFactor: number;
};

export type Sm2Output = {
  repetitions: number;
  intervalDays: number;
  easeFactor: number;
  lapsesDelta: 0 | 1;
};

export function calculateSm2(input: Sm2Input): Sm2Output {
  const quality = input.quality;
  let easeFactor = input.easeFactor;
  let repetitions = input.repetitions;
  let intervalDays = input.intervalDays;
  let lapsesDelta: 0 | 1 = 0;

  easeFactor = Math.max(
    1.3,
    easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02)),
  );

  if (quality < 3) {
    repetitions = 0;
    intervalDays = 1;
    lapsesDelta = 1;
  } else {
    repetitions += 1;
    if (repetitions === 1) {
      intervalDays = 1;
    } else if (repetitions === 2) {
      intervalDays = 6;
    } else {
      intervalDays = Math.max(1, Math.round(intervalDays * easeFactor));
    }
  }

  return {
    repetitions,
    intervalDays,
    easeFactor: Number(easeFactor.toFixed(2)),
    lapsesDelta,
  };
}
