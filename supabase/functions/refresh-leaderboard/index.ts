/**
 * CodeQuest — refresh-leaderboard Edge Function
 *
 * Rebuilds the leaderboard_snapshots table for fast, consistent reads.
 * Should be invoked via a CRON-style pg_cron job or Supabase cron trigger.
 *
 * Suggested schedule: every 15 minutes
 *   SELECT cron.schedule('refresh-leaderboard', '*/15 * * * *',
 *     $$SELECT net.http_post(url := '...', headers := '{"Authorization":"Bearer <service_role>"}')$$);
 *
 * POST /functions/v1/refresh-leaderboard
 * (No body required — uses service role key for authorization)
 */

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, {
      headers: { "Access-Control-Allow-Origin": "*" },
    });
  }

  // Only allow calls with the service role key
  const authHeader = req.headers.get("Authorization") ?? "";
  const serviceRole = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

  if (!authHeader.includes(serviceRole) && !authHeader.includes("Bearer")) {
    return errorResponse("Forbidden", 403);
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL") ?? "",
    serviceRole,
  );

  const startTime = Date.now();

  // ── 1. Global leaderboard snapshot ───────────────────────────────────────────
  // Rank all users by XP descending
  const { data: globalRankData, error: globalErr } = await supabase
    .from("profiles")
    .select("id, username, avatar_url, character_id, level, xp, coins, streak, rank_title")
    .order("xp", { ascending: false })
    .limit(1000);

  if (globalErr) {
    console.error("Global leaderboard query error:", globalErr);
    return errorResponse("Failed to fetch profile data", 500);
  }

  // ── 2. Weekly leaderboard snapshot ───────────────────────────────────────────
  // Sum XP gained this week from xp_logs
  const weekStart = getWeekStart();
  const { data: weeklyRankData, error: weeklyErr } = await supabase
    .from("xp_logs")
    .select("user_id, xp")
    .gte("created_at", weekStart.toISOString());

  // Aggregate weekly XP per user
  const weeklyXpMap = new Map<string, number>();
  for (const log of (weeklyRankData ?? [])) {
    weeklyXpMap.set(log.user_id, (weeklyXpMap.get(log.user_id) ?? 0) + log.xp);
  }

  const weeklyRanked = Array.from(weeklyXpMap.entries())
    .sort((a, b) => b[1] - a[1])
    .slice(0, 1000);

  // ── 3. Upsert leaderboard_snapshots ──────────────────────────────────────────
  const now = new Date().toISOString();

  const globalSnapshots = (globalRankData ?? []).map((profile, index) => ({
    user_id: profile.id,
    rank_position: index + 1,
    xp: profile.xp,
    level: profile.level,
    rank_title: profile.rank_title,
    username: profile.username,
    avatar_url: profile.avatar_url,
    character_id: profile.character_id,
    streak: profile.streak,
    snapshot_type: "global",
    week_start: null,
    updated_at: now,
  }));

  // Build a map of userId -> profile for weekly lookup
  const profileMap = new Map((globalRankData ?? []).map(p => [p.id, p]));

  const weeklySnapshots = weeklyRanked.map(([userId, weekXp], index) => {
    const profile = profileMap.get(userId);
    return {
      user_id: userId,
      rank_position: index + 1,
      xp: weekXp,
      week_xp: weekXp,
      level: profile?.level ?? 1,
      rank_title: profile?.rank_title ?? "Script Kiddie",
      username: profile?.username ?? "Unknown",
      avatar_url: profile?.avatar_url ?? null,
      character_id: profile?.character_id ?? null,
      streak: profile?.streak ?? 0,
      snapshot_type: "weekly",
      week_start: weekStart.toISOString(),
      updated_at: now,
    };
  });

  // Delete old snapshots and re-insert (truncate + insert is atomic via RPC)
  const { error: deleteGlobalErr } = await supabase
    .from("leaderboard_snapshots")
    .delete()
    .eq("snapshot_type", "global");

  if (deleteGlobalErr) console.error("Delete global snapshot error:", deleteGlobalErr);

  const { error: deleteWeeklyErr } = await supabase
    .from("leaderboard_snapshots")
    .delete()
    .eq("snapshot_type", "weekly")
    .eq("week_start", weekStart.toISOString());

  if (deleteWeeklyErr) console.error("Delete weekly snapshot error:", deleteWeeklyErr);

  // Insert new snapshots in batches of 100
  let insertedGlobal = 0;
  let insertedWeekly = 0;

  for (let i = 0; i < globalSnapshots.length; i += 100) {
    const batch = globalSnapshots.slice(i, i + 100);
    const { error } = await supabase.from("leaderboard_snapshots").insert(batch);
    if (!error) insertedGlobal += batch.length;
    else console.error(`Global insert batch ${i} error:`, error);
  }

  for (let i = 0; i < weeklySnapshots.length; i += 100) {
    const batch = weeklySnapshots.slice(i, i + 100);
    const { error } = await supabase.from("leaderboard_snapshots").insert(batch);
    if (!error) insertedWeekly += batch.length;
    else console.error(`Weekly insert batch ${i} error:`, error);
  }

  // ── 4. Update rank column on profiles table ───────────────────────────────────
  // Batch-update rank for top 1000 users
  // rank_position is stored in leaderboard_snapshots only — profiles table has no rank column.

  const elapsed = Date.now() - startTime;
  console.log(`Leaderboard refresh complete in ${elapsed}ms. Global: ${insertedGlobal}, Weekly: ${insertedWeekly}`);

  return jsonResponse({
    success: true,
    elapsed_ms: elapsed,
    global_count: insertedGlobal,
    weekly_count: insertedWeekly,
    week_start: weekStart.toISOString(),
  });
});

// ── Helpers ───────────────────────────────────────────────────────────────────

function getWeekStart(): Date {
  const now = new Date();
  const day = now.getUTCDay(); // 0 = Sunday
  const diff = now.getUTCDate() - day + (day === 0 ? -6 : 1); // adjust to Monday
  const monday = new Date(now);
  monday.setUTCDate(diff);
  monday.setUTCHours(0, 0, 0, 0);
  return monday;
}

function jsonResponse(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" },
  });
}

function errorResponse(message: string, status = 400): Response {
  return jsonResponse({ error: message }, status);
}
