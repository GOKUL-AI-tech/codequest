# CodeQuest – Gamified Coding Learning Platform

A Flutter + Supabase mobile app that turns learning to code into a game. Learners pick a character, travel through worlds and chapters, win battles in the arena and climb the leaderboard, with an AI mentor to help when they get stuck.

## Features

- **Learning path** – worlds, chapters, lessons, quizzes, flashcards and a roadmap
- **Practice modes** – coding challenges, code playground, bug hunt, typing race, algorithm visualiser, boss battles, daily drop
- **Interview prep** – focused practice for common interview topics and a language bridge for moving between languages
- **Arena** – head-to-head battles, team ladder and opportunities board
- **Social** – guilds, chat, leaderboard and notifications
- **AI Mentor** – in-app assistant powered by a Supabase Edge Function
- **Progress** – achievements, certificates, a "Code DNA" profile and a shop
- **Characters & onboarding** – choose a character and skill level on first launch
- **Multilingual UI** – English, Hindi, Tamil, Spanish and French

## Tech Stack

| Layer | Tools |
|-------|-------|
| App | Flutter, Riverpod, GoRouter, Hive, `fl_chart`, Lottie |
| Backend | Supabase (Postgres, Auth, Row Level Security, Storage) |
| Edge Functions | `ai-mentor`, `run-code`, `refresh-leaderboard`, `send-notification` (Deno) |
| Architecture | Clean-architecture layers: `core`, `data`, `domain`, `presentation` |

## Project Structure

```
lib/
├── core/            # constants, theme, router, network, services
├── data/            # datasources (local/remote), models, repositories
├── domain/          # entities, repository contracts, use cases
├── presentation/    # screens, providers, widgets
└── l10n/            # translations
supabase/
├── migrations/      # schema, RLS policies, seed data
└── functions/       # edge functions
```

## Getting Started

1. Create a Supabase project and run the SQL files in `supabase/migrations/` in order.
2. Add your credentials in `lib/core/constants/app_constants.dart` and `lib/core/constants/supabase_config.dart`:
   ```dart
   static const String supabaseUrl = 'https://YOUR-PROJECT.supabase.co';
   static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
   ```
3. Run the app:
   ```bash
   flutter pub get
   flutter run
   ```

See [SETUP_GUIDE.md](SETUP_GUIDE.md) for OAuth, Firebase push notifications and the AI mentor key.

## Author

**Gokul G** – B.Sc. AI & ML · [GitHub](https://github.com/GOKUL-AI-tech) · [LinkedIn](https://www.linkedin.com/in/gokul-g-ai-ml)
