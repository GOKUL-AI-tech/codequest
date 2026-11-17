/**
 * CodeQuest — send-notification Edge Function
 *
 * Sends push notifications via Firebase Cloud Messaging (FCM).
 * Can be invoked directly or triggered by DB webhook / pg_net.
 *
 * POST /functions/v1/send-notification
 * Body: {
 *   user_id: string,           // target user
 *   title: string,
 *   body: string,
 *   type: NotificationType,
 *   data?: Record<string, string>,
 *   image_url?: string
 * }
 *
 * Or bulk:
 * { user_ids: string[], title, body, type, data }
 */

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

// ── Types ─────────────────────────────────────────────────────────────────────

type NotificationType =
  | "xp_reward"
  | "level_up"
  | "streak_reminder"
  | "friend_request"
  | "friend_accepted"
  | "challenge_invite"
  | "battle_result"
  | "tournament_start"
  | "tournament_end"
  | "daily_quest"
  | "achievement_unlocked"
  | "guild_invite"
  | "system";

interface SendNotificationRequest {
  user_id?: string;
  user_ids?: string[];
  title: string;
  body: string;
  type: NotificationType;
  data?: Record<string, string>;
  image_url?: string;
}

// ── Handler ───────────────────────────────────────────────────────────────────

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
      },
    });
  }

  // Allow both service-role and anon calls (service-role for server-to-server)
  const authHeader = req.headers.get("Authorization");
  const serviceRole = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL") ?? "",
    authHeader?.includes(serviceRole) ? serviceRole : (Deno.env.get("SUPABASE_ANON_KEY") ?? ""),
    { global: { headers: { Authorization: authHeader ?? "" } } }
  );

  let body: SendNotificationRequest;
  try {
    body = await req.json();
  } catch {
    return errorResponse("Invalid JSON", 400);
  }

  const { user_id, user_ids, title, body: notifBody, type, data, image_url } = body;

  const targetUserIds: string[] = user_ids ?? (user_id ? [user_id] : []);
  if (!targetUserIds.length) return errorResponse("user_id or user_ids required", 400);

  // ── Fetch FCM tokens for target users ─────────────────────────────────────────
  const { data: profilesData, error: profilesError } = await supabase
    .from("profiles")
    .select("id, fcm_token")
    .in("id", targetUserIds)
    .not("fcm_token", "is", null);

  if (profilesError) {
    console.error("Profile fetch error:", profilesError);
    return errorResponse("Failed to fetch user tokens", 500);
  }

  const tokens = (profilesData ?? [])
    .map(p => p.fcm_token as string)
    .filter(Boolean);

  if (!tokens.length) {
    // No tokens — still save to DB but skip FCM
    await saveNotificationsToDb(supabase, targetUserIds, title, notifBody, type);
    return jsonResponse({ sent: 0, saved: targetUserIds.length, message: "Saved to DB, no FCM tokens" });
  }

  // ── Send via FCM HTTP v1 API ──────────────────────────────────────────────────
  const FCM_SERVER_KEY = Deno.env.get("FCM_SERVER_KEY") ?? "";
  const FCM_PROJECT_ID = Deno.env.get("FCM_PROJECT_ID") ?? "";

  let sentCount = 0;
  const fcmErrors: string[] = [];

  // FCM supports up to 500 tokens per multicast request
  const BATCH_SIZE = 500;
  for (let i = 0; i < tokens.length; i += BATCH_SIZE) {
    const batch = tokens.slice(i, i + BATCH_SIZE);
    try {
      const fcmResponse = await fetch(
        `https://fcm.googleapis.com/v1/projects/${FCM_PROJECT_ID}/messages:send`,
        {
          method: "POST",
          headers: {
            "Authorization": `Bearer ${FCM_SERVER_KEY}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            message: {
              // Use token for single, topic for broadcast
              ...(batch.length === 1 ? { token: batch[0] } : {}),
              notification: {
                title,
                body: notifBody,
                ...(image_url ? { image: image_url } : {}),
              },
              data: {
                type,
                click_action: "FLUTTER_NOTIFICATION_CLICK",
                ...(data ?? {}),
              },
              android: {
                priority: "high",
                notification: {
                  channel_id: "codequest_default",
                  sound: "default",
                  color: "#00F5FF",
                  click_action: "FLUTTER_NOTIFICATION_CLICK",
                },
              },
              apns: {
                payload: {
                  aps: {
                    sound: "default",
                    badge: 1,
                    "content-available": 1,
                  },
                },
                headers: {
                  "apns-priority": "10",
                },
              },
            },
          }),
        }
      );

      if (fcmResponse.ok) {
        sentCount += batch.length;
      } else {
        const errText = await fcmResponse.text();
        fcmErrors.push(`FCM batch error: ${fcmResponse.status} ${errText}`);
      }
    } catch (err) {
      fcmErrors.push(`FCM request failed: ${err.message}`);
    }
  }

  // ── Persist notifications to DB ───────────────────────────────────────────────
  await saveNotificationsToDb(supabase, targetUserIds, title, notifBody, type);

  return jsonResponse({
    sent: sentCount,
    total_tokens: tokens.length,
    errors: fcmErrors.length > 0 ? fcmErrors : undefined,
  });
});

// ── Helpers ───────────────────────────────────────────────────────────────────

async function saveNotificationsToDb(
  supabase: ReturnType<typeof createClient>,
  userIds: string[],
  title: string,
  body: string,
  type: NotificationType,
) {
  const records = userIds.map(userId => ({
    user_id: userId,
    type,
    title,
    body,
    is_read: false,
  }));

  const { error } = await supabase.from("notifications").insert(records);
  if (error) console.error("DB notification insert error:", error);
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
