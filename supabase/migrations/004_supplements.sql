-- ═══════════════════════════════════════════════════════════════════════════
-- Migration 004 — Supplementary tables & columns
-- Run after 001, 002, 003
-- ═══════════════════════════════════════════════════════════════════════════

-- ── 1. Add tag column to guilds ──────────────────────────────────────────────
ALTER TABLE public.guilds
  ADD COLUMN IF NOT EXISTS tag VARCHAR(5),
  ADD COLUMN IF NOT EXISTS is_member BOOLEAN DEFAULT FALSE; -- computed client-side, not stored

-- Unique tag constraint
CREATE UNIQUE INDEX IF NOT EXISTS guilds_tag_unique ON public.guilds (tag)
  WHERE tag IS NOT NULL;

-- ── 2. Add fcm_token to profiles (for push notifications) ────────────────────
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS fcm_token TEXT,
  ADD COLUMN IF NOT EXISTS is_online BOOLEAN DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS last_seen_at TIMESTAMPTZ;

-- ── 3. Code submissions table (for run-code edge function) ────────────────────
CREATE TABLE IF NOT EXISTS public.code_submissions (
  id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id      UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  challenge_id UUID REFERENCES public.coding_challenges(id) ON DELETE SET NULL,
  language_id  INTEGER NOT NULL,
  source_code  TEXT NOT NULL,
  passed       BOOLEAN NOT NULL DEFAULT FALSE,
  test_results JSONB,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS code_submissions_user_idx ON public.code_submissions (user_id);
CREATE INDEX IF NOT EXISTS code_submissions_challenge_idx ON public.code_submissions (challenge_id);

-- RLS for code_submissions
ALTER TABLE public.code_submissions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own submissions"
  ON public.code_submissions FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own submissions"
  ON public.code_submissions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- ── 4. Add is_read to chat_messages ─────────────────────────────────────────
ALTER TABLE public.chat_messages
  ADD COLUMN IF NOT EXISTS is_read BOOLEAN DEFAULT FALSE;

CREATE INDEX IF NOT EXISTS chat_messages_unread_idx
  ON public.chat_messages (room_id, sender_id, is_read)
  WHERE is_read = FALSE;

-- ── 5. Leaderboard snapshot type index ───────────────────────────────────────
CREATE INDEX IF NOT EXISTS leaderboard_snapshots_type_idx
  ON public.leaderboard_snapshots (snapshot_type, rank_position);

-- ── 6. Enable realtime for code_submissions ───────────────────────────────────
ALTER PUBLICATION supabase_realtime ADD TABLE public.code_submissions;

-- ── 7. Helper function: get_user_guild_id ────────────────────────────────────
CREATE OR REPLACE FUNCTION public.get_user_guild_id(p_user_id UUID)
RETURNS UUID AS $$
  SELECT guild_id FROM public.guild_members
  WHERE user_id = p_user_id
  LIMIT 1;
$$ LANGUAGE sql STABLE SECURITY DEFINER;

-- ── 8. Add guild tag to guilds seed (update existing rows) ───────────────────
-- Note: actual tags would be set when creating guilds via the app
-- This is just to ensure existing seed data doesn't violate constraints
