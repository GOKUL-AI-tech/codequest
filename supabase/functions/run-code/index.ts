/**
 * CodeQuest — run-code Edge Function
 *
 * Executes user-submitted code in a sandboxed environment and returns
 * stdout, stderr, and pass/fail for each test case.
 *
 * Uses the Judge0 CE API (self-hosted or cloud) as the execution backend.
 * Set JUDGE0_API_URL and JUDGE0_API_KEY in Supabase project secrets.
 *
 * Invoke via: POST /functions/v1/run-code
 * Body: { language_id: number, source_code: string, test_cases: TestCase[] }
 * TestCase: { input: string, expected_output: string }
 */

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

// ── Types ─────────────────────────────────────────────────────────────────────

interface TestCase {
  id?: string;
  input: string;
  expected_output: string;
}

interface RunCodeRequest {
  language_id: number; // Judge0 language ID
  source_code: string;
  test_cases: TestCase[];
  challenge_id?: string;
  time_limit?: number;   // seconds (default 5)
  memory_limit?: number; // kilobytes (default 262144 = 256MB)
}

interface TestResult {
  id?: string;
  input: string;
  expected_output: string;
  actual_output: string;
  stderr: string;
  status: "accepted" | "wrong_answer" | "time_limit" | "runtime_error" | "compile_error";
  time: string;
  memory: number;
  passed: boolean;
}

// Judge0 Extra CE language IDs
// Full list: https://ce.judge0.com/languages/
const JUDGE0_LANGUAGE_MAP: Record<string, number> = {
  python: 71,      // Python 3.8.1
  javascript: 63,  // JavaScript (Node.js 12.14.0)
  typescript: 74,  // TypeScript 3.7.4
  java: 62,        // Java (OpenJDK 13.0.1)
  cpp: 54,         // C++ (GCC 9.2.0)
  c: 50,           // C (GCC 9.2.0)
  dart: 90,        // Dart 2.19.2  ← Extra CE only
  kotlin: 78,      // Kotlin 1.3.70 ← Extra CE only
  swift: 83,       // Swift 5.2.3  ← Extra CE only
  go: 60,          // Go 1.13.5
  rust: 73,        // Rust 1.40.0
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

  if (req.method !== "POST") {
    return errorResponse("Method not allowed", 405);
  }

  // ── Auth check ──────────────────────────────────────────────────────────────
  const authHeader = req.headers.get("Authorization");

  const supabaseClient = createClient(
    Deno.env.get("SUPABASE_URL") ?? "",
    Deno.env.get("SUPABASE_ANON_KEY") ?? "",
    authHeader ? { global: { headers: { Authorization: authHeader } } } : {}
  );

  // Try to get user — allow unauthenticated for testing if no auth header
  let userId = "test-user";
  if (authHeader) {
    const { data: { user } } = await supabaseClient.auth.getUser();
    if (user) userId = user.id;
  }

  // ── Parse body ──────────────────────────────────────────────────────────────
  let body: RunCodeRequest;
  try {
    body = await req.json();
  } catch {
    return errorResponse("Invalid JSON body", 400);
  }

  const { language_id, source_code, test_cases, time_limit = 5, memory_limit = 262144 } = body;

  if (!source_code || !test_cases?.length) {
    return errorResponse("source_code and test_cases are required", 400);
  }

  // Rate limit: max 20 submissions per user per minute
  // (Implement with Supabase DB or Redis in production)

  // ── Judge0 API ──────────────────────────────────────────────────────────────
  const JUDGE0_URL = Deno.env.get("JUDGE0_API_URL") ?? "https://judge0-extra-ce.p.rapidapi.com";
  const JUDGE0_KEY = Deno.env.get("JUDGE0_API_KEY") ?? "";

  const results: TestResult[] = [];
  let allPassed = true;

  for (const testCase of test_cases) {
    try {
      // Submit to Judge0
      const submitResponse = await fetch(`${JUDGE0_URL}/submissions?base64_encoded=false&wait=false`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-RapidAPI-Key": JUDGE0_KEY,
          "X-RapidAPI-Host": "judge0-extra-ce.p.rapidapi.com",
        },
        body: JSON.stringify({
          language_id,
          source_code,
          stdin: testCase.input,
          expected_output: testCase.expected_output,
          cpu_time_limit: time_limit,
          memory_limit,
        }),
      });

      if (!submitResponse.ok) {
        throw new Error(`Judge0 submit failed: ${submitResponse.status}`);
      }

      const { token } = await submitResponse.json();

      // Poll for result (max 10 attempts, 500ms apart)
      let result = null;
      for (let attempt = 0; attempt < 10; attempt++) {
        await new Promise(r => setTimeout(r, 500));
        const pollResponse = await fetch(
          `${JUDGE0_URL}/submissions/${token}?base64_encoded=false&fields=status,stdout,stderr,time,memory,compile_output`,
          {
            headers: {
              "X-RapidAPI-Key": JUDGE0_KEY,
              "X-RapidAPI-Host": "judge0-extra-ce.p.rapidapi.com",
            },
          }
        );
        const data = await pollResponse.json();
        // Status ID 1 = In Queue, 2 = Processing
        if (data.status?.id > 2) {
          result = data;
          break;
        }
      }

      if (!result) {
        throw new Error("Execution timed out waiting for Judge0 result");
      }

      const statusId = result.status?.id;
      let status: TestResult["status"];
      if (statusId === 3) status = "accepted";
      else if (statusId === 4) status = "wrong_answer";
      else if (statusId === 5) status = "time_limit";
      else if (statusId === 6) status = "compile_error";
      else status = "runtime_error";

      const passed = statusId === 3;
      if (!passed) allPassed = false;

      results.push({
        id: testCase.id,
        input: testCase.input,
        expected_output: testCase.expected_output,
        actual_output: result.stdout ?? "",
        stderr: result.stderr ?? result.compile_output ?? "",
        status,
        time: result.time ?? "0",
        memory: result.memory ?? 0,
        passed,
      });
    } catch (err) {
      allPassed = false;
      results.push({
        id: testCase.id,
        input: testCase.input,
        expected_output: testCase.expected_output,
        actual_output: "",
        stderr: `Execution error: ${err.message}`,
        status: "runtime_error",
        time: "0",
        memory: 0,
        passed: false,
      });
    }
  }

  // ── Log submission to DB ─────────────────────────────────────────────────────
  if (body.challenge_id) {
    await supabaseClient.from("code_submissions").insert({
      user_id: userId,
      challenge_id: body.challenge_id,
      language_id,
      source_code,
      passed: allPassed,
      test_results: results,
    }).maybeSingle();
  }

  return jsonResponse({
    passed: allPassed,
    results,
    total: test_cases.length,
    passed_count: results.filter(r => r.passed).length,
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
