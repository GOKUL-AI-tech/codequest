/**
 * CodeQuest — ai-mentor Edge Function
 *
 * Provides AI-powered coding mentorship via Anthropic Claude API.
 * Supports: explanations, bug fixing, hints, code review, practice problems.
 *
 * POST /functions/v1/ai-mentor
 * Body: {
 *   message: string,
 *   conversation_id?: string,
 *   context?: { language?: string, code?: string, challenge_id?: string },
 *   mode?: "chat" | "hint" | "review" | "explain" | "generate_problem"
 * }
 */

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

// ── Types ─────────────────────────────────────────────────────────────────────

interface AiMentorRequest {
  message: string;
  conversation_id?: string;
  context?: {
    language?: string;
    code?: string;
    challenge_id?: string;
    lesson_topic?: string;
    user_level?: number;
  };
  mode?: "chat" | "hint" | "review" | "explain" | "generate_problem";
}

interface ConversationMessage {
  role: "user" | "assistant";
  content: string;
}

// ── System prompts by mode ─────────────────────────────────────────────────────

const SYSTEM_PROMPTS: Record<string, string> = {
  chat: `You are ALEX — an encouraging AI coding mentor for CodeQuest, a gamified coding education app.
You help learners of all levels understand programming concepts in a friendly, gaming-themed way.
Keep responses concise (under 200 words unless asked for detail), use simple language, and always be positive and motivating.
Use coding metaphors from games when helpful. Format code with markdown code blocks.
Never solve exercises completely unless the user is genuinely stuck — guide them with hints instead.`,

  hint: `You are ALEX, the CodeQuest AI mentor giving a hint to a student.
Give ONE clear hint that nudges them toward the solution without revealing it.
Be encouraging and specific. Keep it under 80 words.`,

  review: `You are ALEX, the CodeQuest AI code reviewer.
Review the provided code for: correctness, style, efficiency, and common beginner mistakes.
Format your response as:
1. ✅ What's good
2. ⚠️ Issues found
3. 💡 Suggestions
Keep it constructive and beginner-friendly.`,

  explain: `You are ALEX, the CodeQuest AI explainer.
Explain the given concept or code snippet clearly and simply.
Use an analogy or real-world example. Break it into steps if helpful.
Target audience: beginner to intermediate programmers.`,

  generate_problem: `You are ALEX, the CodeQuest problem generator.
Generate a coding practice problem appropriate for the user's level and chosen language.
Format:
## Problem Title
**Difficulty**: Easy/Medium/Hard
**Description**: [clear problem statement]
**Input**: [format description]
**Output**: [format description]
**Example Input/Output**: [1-2 examples]
**Constraints**: [time/space/value constraints]
Make it engaging and gamified — use creative scenarios!`,
};

// ── Handler ───────────────────────────────────────────────────────────────────

serve(async (req) => {
  // CORS preflight
  if (req.method === "OPTIONS") {
    return new Response(null, {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
        "Access-Control-Allow-Methods": "POST, OPTIONS",
      },
    });
  }

  if (req.method !== "POST") return errorResponse("Method not allowed", 405);

  // ── Auth check ──────────────────────────────────────────────────────────────
  const authHeader = req.headers.get("Authorization");
  if (!authHeader) return errorResponse("Unauthorized", 401);

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL") ?? "",
    Deno.env.get("SUPABASE_ANON_KEY") ?? "",
    { global: { headers: { Authorization: authHeader } } }
  );

  const { data: { user }, error: authError } = await supabase.auth.getUser();
  if (authError || !user) return errorResponse("Unauthorized", 401);

  // ── Parse body ──────────────────────────────────────────────────────────────
  let body: AiMentorRequest;
  try {
    body = await req.json();
  } catch {
    return errorResponse("Invalid JSON body", 400);
  }

  const { message, conversation_id, context, mode = "chat" } = body;
  if (!message?.trim()) return errorResponse("message is required", 400);

  // ── Load conversation history ────────────────────────────────────────────────
  let conversationHistory: ConversationMessage[] = [];
  let activeConversationId = conversation_id;

  if (activeConversationId) {
    const { data: historyData } = await supabase
      .from("ai_messages")
      .select("role, content")
      .eq("conversation_id", activeConversationId)
      .order("created_at", { ascending: true })
      .limit(20); // last 20 messages for context window

    conversationHistory = (historyData ?? []) as ConversationMessage[];
  } else {
    // Create new conversation
    const { data: convData } = await supabase
      .from("ai_conversations")
      .insert({ user_id: user.id, mode })
      .select("id")
      .single();
    activeConversationId = convData?.id;
  }

  // ── Build user message (with context injection) ───────────────────────────────
  let userMessage = message;
  if (context) {
    const parts: string[] = [];
    if (context.language) parts.push(`Language: ${context.language}`);
    if (context.lesson_topic) parts.push(`Topic: ${context.lesson_topic}`);
    if (context.user_level) parts.push(`My level: ${context.user_level}`);
    if (context.code) parts.push(`\`\`\`\n${context.code}\n\`\`\``);
    if (parts.length > 0) {
      userMessage = `[Context: ${parts.join(", ")}]\n\n${message}`;
    }
  }

  // ── Call Claude API ──────────────────────────────────────────────────────────
  const ANTHROPIC_API_KEY = Deno.env.get("ANTHROPIC_API_KEY") ?? "";
  if (!ANTHROPIC_API_KEY) return errorResponse("AI service not configured", 503);

  const messages = [
    ...conversationHistory.map(m => ({ role: m.role, content: m.content })),
    { role: "user" as const, content: userMessage },
  ];

  let aiResponse = "";
  try {
    const claudeResponse = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "x-api-key": ANTHROPIC_API_KEY,
        "anthropic-version": "2023-06-01",
      },
      body: JSON.stringify({
        model: "claude-haiku-4-5-20251001",
        max_tokens: 1024,
        system: SYSTEM_PROMPTS[mode] ?? SYSTEM_PROMPTS.chat,
        messages,
      }),
    });

    if (!claudeResponse.ok) {
      const errText = await claudeResponse.text();
      throw new Error(`Claude API error ${claudeResponse.status}: ${errText}`);
    }

    const claudeData = await claudeResponse.json();
    aiResponse = claudeData.content?.[0]?.text ?? "I couldn't generate a response. Please try again!";
  } catch (err) {
    console.error("AI error:", err);
    // Fallback encouraging message
    aiResponse = "Hey there! I'm having a little trouble connecting right now. 🤖 Try again in a moment — I'll be back to help you level up your coding skills!";
  }

  // ── Persist messages ─────────────────────────────────────────────────────────
  if (activeConversationId) {
    await supabase.from("ai_messages").insert([
      { conversation_id: activeConversationId, role: "user", content: message },
      { conversation_id: activeConversationId, role: "assistant", content: aiResponse },
    ]);
  }

  return jsonResponse({
    response: aiResponse,
    conversation_id: activeConversationId,
    mode,
  });
});

// ── Helpers ───────────────────────────────────────────────────────────────────

function jsonResponse(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
    },
  });
}

function errorResponse(message: string, status = 400): Response {
  return jsonResponse({ error: message }, status);
}
