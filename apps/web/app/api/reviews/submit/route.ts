import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";
import { calculateSm2 } from "@masteri/core";

const SubmitBodySchema = z.object({
  cardId: z.string().uuid(),
  quality: z.number().int().min(0).max(5),
});

export async function POST(request: NextRequest) {
  try {
    const supabase = await createSupabaseServerClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    const body = SubmitBodySchema.parse(await request.json());
    const admin = createSupabaseAdminClient();

    const { data: card } = await admin
      .from("spaced_rep_cards")
      .select("id, user_id, ease_factor, interval_days, repetitions, lapses")
      .eq("id", body.cardId)
      .eq("user_id", user.id)
      .single();

    if (!card) return NextResponse.json({ error: "Card not found" }, { status: 404 });

    const sm2Result = calculateSm2({
      quality: body.quality as 0 | 1 | 2 | 3 | 4 | 5,
      repetitions: card.repetitions as number,
      intervalDays: card.interval_days as number,
      easeFactor: card.ease_factor as number,
    });

    const nextReviewDate = new Date(Date.now() + sm2Result.intervalDays * 86400000).toISOString().split("T")[0];

    await admin.from("review_logs").insert({
      card_id: card.id,
      quality: body.quality,
      previous_interval_days: card.interval_days,
      next_interval_days: sm2Result.intervalDays,
      previous_ease_factor: card.ease_factor,
      next_ease_factor: sm2Result.easeFactor,
    });

    await admin.from("spaced_rep_cards").update({
      ease_factor: sm2Result.easeFactor,
      interval_days: sm2Result.intervalDays,
      repetitions: sm2Result.repetitions,
      lapses: (card.lapses as number) + sm2Result.lapsesDelta,
      next_review_date: nextReviewDate,
      last_reviewed_at: new Date().toISOString(),
    }).eq("id", card.id);

    return NextResponse.json({ nextReviewDate, intervalDays: sm2Result.intervalDays });
  } catch (e) {
    if (e instanceof z.ZodError) return NextResponse.json({ error: "Invalid input" }, { status: 400 });
    return NextResponse.json({ error: "Internal error" }, { status: 500 });
  }
}
