import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

// ─── Mode definition ──────────────────────────────────────────────────────────

enum MentorMode { chat, code, study, exam }

extension MentorModeX on MentorMode {
  String get label => switch (this) {
        MentorMode.chat  => 'Chat',
        MentorMode.code  => 'Code',
        MentorMode.study => 'Study',
        MentorMode.exam  => 'Exam',
      };

  String get emoji => switch (this) {
        MentorMode.chat  => '💬',
        MentorMode.code  => '💻',
        MentorMode.study => '📚',
        MentorMode.exam  => '🏆',
      };

  Color get color => switch (this) {
        MentorMode.chat  => AppColors.neonCyan,
        MentorMode.code  => AppColors.neonGreen,
        MentorMode.study => const Color(0xFF7B2FFF),
        MentorMode.exam  => const Color(0xFFFFD700),
      };

  List<String> get quickPrompts => switch (this) {
        MentorMode.chat => [
            '👋 What can you help with?',
            '🎯 Set a goal for me',
            '🔥 Motivate me',
            '📅 Daily mission',
            '🏅 How do I rank up?',
            '🤔 Career advice',
          ],
        MentorMode.code => [
            '🐛 Fix my bug',
            '⚡ Code review',
            '💡 Explain this code',
            '🧩 Give me a challenge',
            '📊 Big-O analysis',
            '🔄 Refactor this',
          ],
        MentorMode.study => [
            '📖 Study plan for me',
            '🗂️ Summarise a topic',
            '🃏 Make flashcards',
            '⏱️ Pomodoro session',
            '🔁 Spaced repetition tips',
            '📝 Revision notes',
          ],
        MentorMode.exam => [
            '❓ Quiz me!',
            '📝 Mock test',
            '⚠️ Find weak areas',
            '🎯 5-mark questions',
            '📋 Last-minute tips',
            '🏁 Time-box practice',
          ],
      };

  String get systemPrompt => '''
You are ALEX, an intelligent study and coding mentor inside CodeQuest — a gamified coding learning app.

PERSONALITY:
- Friendly, supportive, and motivating. Talk like a smart friend, not a textbook.
- Encouraging without being pushy. Keep energy positive.
- Celebrate every win, no matter how small.
- Never guilt-trip or shame the user.

CORE MISSION:
Every response should provide value toward: learning, skill-building, coding, exam prep, career growth, or productivity — while staying fun.

GAMIFICATION (always mention when relevant):
- Award XP for learning activities (e.g. "You just earned 30 XP! ⭐")
- Mention streak bonuses ("You're on a 5-day streak! 🔥 Keep it up!")
- Suggest daily missions ("Today's mission: solve 1 easy problem")
- Encourage healthy competition ("This puts you in top 20% of learners!")

${switch (this) {
      MentorMode.chat => '''
CURRENT MODE: Chat Mode
- Respond naturally and conversationally.
- Gradually connect to learning, skills, coding, or careers when it fits.
- Suggest activities: solving a challenge, learning a concept, taking a quiz, building a project.
- If the user is bored, suggest a fun mini-challenge.
- Respect their decision if they don't want to study.''',
      MentorMode.code => '''
CURRENT MODE: Coding Mode
- Help debug code: ask for error message + relevant code first.
- Give HINTS before full solutions — encourage thinking.
- Explain errors clearly: what happened, why, how to fix.
- Support Java, Python, C++, JavaScript, Dart.
- After solving, suggest a similar harder problem.
- Always add a TIP or BEST PRACTICE at the end.
- Format code in proper code blocks.''',
      MentorMode.study => '''
CURRENT MODE: Study Mode
- Create personalised study plans when asked.
- Summarise topics clearly with key points and examples.
- Generate flashcard-style Q&A pairs.
- Suggest Pomodoro sessions and spaced repetition schedules.
- Make revision notes concise and scannable (bullets, headers).
- Track weak areas and recommend targeted practice.''',
      MentorMode.exam => '''
CURRENT MODE: Exam Mode
- Generate MCQs with 4 options and explanations.
- Create short-answer and long-answer questions.
- Simulate timed mock tests.
- Identify weak areas from wrong answers.
- Give last-minute exam tips.
- Focus on high-probability exam topics.
- Format MCQs clearly: question → options A/B/C/D → answer → explanation.''',
    }}

CODING LANGUAGES SUPPORTED: Python, Java, C++, JavaScript, Dart, C
''';
}

// ─── Message model ────────────────────────────────────────────────────────────

class _ChatMessage {
  final String content;
  final bool isBot;
  final DateTime timestamp;
  final MentorMode mode;
  final int? xpAwarded;

  _ChatMessage({
    required this.content,
    required this.isBot,
    required this.timestamp,
    required this.mode,
    this.xpAwarded,
  });
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class AiMentorScreen extends ConsumerStatefulWidget {
  const AiMentorScreen({super.key});

  @override
  ConsumerState<AiMentorScreen> createState() => _AiMentorScreenState();
}

class _AiMentorScreenState extends ConsumerState<AiMentorScreen>
    with TickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];

  bool _isTyping = false;
  MentorMode _mode = MentorMode.chat;
  int _sessionXp = 0;

  // Conversation history for real API (includes system + all turns)
  final List<Map<String, String>> _apiHistory = [];

  @override
  void initState() {
    super.initState();
    _addWelcome();
  }

  void _addWelcome() {
    _messages.add(_ChatMessage(
      content: "Hey! 👋 I'm **ALEX**, your personal coding mentor!\n\n"
          "I'm here to help you:\n"
          "• 🐛 Debug & fix your code\n"
          "• 💡 Explain any concept step-by-step\n"
          "• 🧩 Give you coding challenges\n"
          "• 📚 Create study plans\n"
          "• 🏆 Prep you for exams & interviews\n"
          "• 🔥 Keep you motivated every day\n\n"
          "Pick a mode above or just ask me anything. Let's level up together! 🚀\n\n"
          "⭐ **+10 XP** for opening the mentor today!",
      isBot: true,
      timestamp: DateTime.now(),
      mode: _mode,
      xpAwarded: 10,
    ));
    _sessionXp += 10;
  }

  // ── API call ────────────────────────────────────────────────────────────────

  Future<String> _callOpenAI(String userMessage) async {
    final apiKey = AppConstants.aiMentorApiKey;

    // If no real key, use smart mock
    if (apiKey == 'YOUR_OPENAI_OR_GEMINI_KEY' || apiKey.isEmpty) {
      return _smartMock(userMessage);
    }

    // Build message list: system + history + new user message
    final messages = [
      {'role': 'system', 'content': _mode.systemPrompt},
      ..._apiHistory,
      {'role': 'user', 'content': userMessage},
    ];

    try {
      final res = await http.post(
        Uri.parse('${AppConstants.aiMentorBaseUrl}/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': AppConstants.aiMentorModel,
          'messages': messages,
          'max_tokens': 1000,
          'temperature': 0.75,
        }),
      ).timeout(const Duration(seconds: 30));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final reply = data['choices'][0]['message']['content'] as String;
        // Add to history
        _apiHistory.add({'role': 'user', 'content': userMessage});
        _apiHistory.add({'role': 'assistant', 'content': reply});
        // Keep history bounded (last 20 turns = 40 messages)
        if (_apiHistory.length > 40) {
          _apiHistory.removeRange(0, 2);
        }
        return reply;
      } else {
        return _smartMock(userMessage);
      }
    } catch (_) {
      return _smartMock(userMessage);
    }
  }

  // ── Smart mock — matches SkillConnect AI personality ──────────────────────

  String _smartMock(String input) {
    final low = input.toLowerCase();

    // ── Coding Mode responses ─────────────────────────────────────────────
    if (_mode == MentorMode.code) {
      if (low.contains('bug') || low.contains('error') || low.contains('fix')) {
        return "Let's squash that bug! 🐛\n\n"
            "To help you effectively, share:\n"
            "1️⃣ The **error message** (exact text)\n"
            "2️⃣ The **relevant code** snippet\n"
            "3️⃣ What you **expected** vs what **happened**\n\n"
            "While you do that, here are the most common culprits:\n\n"
            "🐍 **Python**\n"
            "• `IndentationError` — check spacing (use spaces, not tabs)\n"
            "• `NameError` — variable not defined before use\n"
            "• `TypeError` — wrong type passed to function\n"
            "• `IndexError` — list index out of range\n\n"
            "☕ **Java / Dart**\n"
            "• `NullPointerException` — object is null, check before use\n"
            "• `ClassCastException` — wrong cast\n\n"
            "Paste your code and we'll fix it step by step! 💪\n\n"
            "⭐ Debugging earns you **+20 XP** when solved!";
      }

      if (low.contains('review') || low.contains('refactor')) {
        return "Code review mode activated! 🔍\n\n"
            "Paste your code and I'll check:\n\n"
            "✅ **Correctness** — Does it work as expected?\n"
            "⚡ **Performance** — Any O(n²) hiding in there?\n"
            "📖 **Readability** — Can a teammate understand it?\n"
            "🛡️ **Edge cases** — Empty input? Negative numbers?\n"
            "🏗️ **Structure** — Functions, naming, separation of concerns\n\n"
            "I'll give you a score and actionable improvements.\n"
            "Let's see that code! 🚀";
      }

      if (low.contains('challenge') || low.contains('problem') || low.contains('practice')) {
        return "Here's your coding challenge! 🧩\n\n"
            "━━━━━━━━━━━━━━━━━━━━━━━\n"
            "**CHALLENGE: Two Sum**\n"
            "━━━━━━━━━━━━━━━━━━━━━━━\n\n"
            "Given an array of integers and a target, return indices of the two numbers that add up to the target.\n\n"
            "```python\n"
            "def two_sum(nums: list, target: int) -> list:\n"
            "    # Your solution here\n"
            "    pass\n\n"
            "# Test cases\n"
            "print(two_sum([2,7,11,15], 9))   # [0,1]\n"
            "print(two_sum([3,2,4], 6))        # [1,2]\n"
            "```\n\n"
            "🏷️ Difficulty: 🌟 Easy → 🌟🌟 Medium with O(n) constraint\n"
            "⏱️ Target time: 15 minutes\n\n"
            "**Hints** (read one at a time):\n"
            "1. Brute force: try every pair — O(n²)\n"
            "2. Can you use a dictionary to avoid the inner loop?\n"
            "3. Store `target - num` as you scan\n\n"
            "⭐ Solve it → **+100 XP** | With O(n) solution → **+50 bonus XP**!\n\n"
            "Ready? Go! 🚀";
      }

      if (low.contains('big') && low.contains('o') || low.contains('complexity')) {
        return "Big-O Complexity — let's break it down! 📊\n\n"
            "| Notation | Name | Example |\n"
            "|---|---|---|\n"
            "| O(1) | Constant | Array index access |\n"
            "| O(log n) | Logarithmic | Binary search |\n"
            "| O(n) | Linear | Simple loop |\n"
            "| O(n log n) | Log-linear | Merge sort |\n"
            "| O(n²) | Quadratic | Nested loops |\n"
            "| O(2ⁿ) | Exponential | Brute-force subsets |\n\n"
            "**Golden rules:**\n"
            "• Drop constants: O(2n) → O(n)\n"
            "• Drop non-dominant terms: O(n² + n) → O(n²)\n"
            "• Nested loops usually multiply: O(n) × O(n) = O(n²)\n\n"
            "Share a function and I'll analyse its complexity! 🔬\n\n"
            "⭐ Understanding Big-O → **+30 XP**!";
      }
    }

    // ── Study Mode responses ──────────────────────────────────────────────
    if (_mode == MentorMode.study) {
      if (low.contains('plan') || low.contains('schedule')) {
        return "Let's build your personalised study plan! 📅\n\n"
            "Quick questions first:\n"
            "1. What topic/language are you learning?\n"
            "2. What's your current level? (Beginner / Intermediate / Advanced)\n"
            "3. How many hours per day can you study?\n"
            "4. Do you have a deadline? (Exam, interview, etc.)\n\n"
            "Meanwhile, here's a **general 4-week coding plan**:\n\n"
            "**Week 1 — Foundations**\n"
            "• Days 1–3: Syntax, variables, control flow\n"
            "• Days 4–5: Functions, scope\n"
            "• Days 6–7: Review + 3 easy problems\n\n"
            "**Week 2 — Data Structures**\n"
            "• Arrays, strings, lists, dictionaries\n"
            "• 2 problems per day\n\n"
            "**Week 3 — OOP + Algorithms**\n"
            "• Classes, sorting, searching\n"
            "• 3 problems per day\n\n"
            "**Week 4 — Projects + Review**\n"
            "• Build a mini-project\n"
            "• Mock interview practice\n\n"
            "Answer my questions and I'll customise this for you! 🎯\n\n"
            "⭐ Planning your study = **+20 XP**!";
      }

      if (low.contains('flashcard') || low.contains('flash card')) {
        return "Flashcard set generated! 🃏\n\n"
            "**Topic: Python Fundamentals**\n\n"
            "━━━ Card 1 ━━━\n"
            "**Q:** What is a list comprehension?\n"
            "**A:** A concise way to create lists.\n"
            "```python\n[x**2 for x in range(5)]  # [0,1,4,9,16]\n```\n\n"
            "━━━ Card 2 ━━━\n"
            "**Q:** Difference between `==` and `is`?\n"
            "**A:** `==` compares values; `is` compares identity (same object in memory).\n\n"
            "━━━ Card 3 ━━━\n"
            "**Q:** What does `*args` do?\n"
            "**A:** Collects extra positional arguments into a tuple.\n\n"
            "━━━ Card 4 ━━━\n"
            "**Q:** What is a decorator?\n"
            "**A:** A function that wraps another function to add behaviour.\n\n"
            "Tell me a topic and I'll generate a full flashcard deck for you! 📚\n\n"
            "⭐ Flashcard review → **+15 XP** per session!";
      }

      if (low.contains('pomodoro') || low.contains('focus') || low.contains('session')) {
        return "Pomodoro session starting! ⏱️\n\n"
            "**The Pomodoro Technique:**\n"
            "🍅 25 min focused work\n"
            "☕ 5 min break\n"
            "Repeat 4 times → 🏖️ 15–30 min long break\n\n"
            "**Today's session plan:**\n"
            "```\n"
            "🍅 Pomodoro 1 → Read / watch concept\n"
            "☕ Break → Walk, stretch\n"
            "🍅 Pomodoro 2 → Code it yourself\n"
            "☕ Break → Hydrate\n"
            "🍅 Pomodoro 3 → Solve 1 related problem\n"
            "☕ Break → Rest eyes\n"
            "🍅 Pomodoro 4 → Review + notes\n"
            "🏖️ Long break → Reward yourself!\n"
            "```\n\n"
            "**Tips for deep focus:**\n"
            "• Phone on silent & face-down\n"
            "• Use lo-fi music (no lyrics)\n"
            "• Have water nearby\n"
            "• One task per Pomodoro\n\n"
            "⭐ Complete all 4 Pomodoros → **+50 XP** + 🔥 streak bonus!";
      }
    }

    // ── Exam Mode responses ───────────────────────────────────────────────
    if (_mode == MentorMode.exam) {
      if (low.contains('quiz') || low.contains('mcq') || low.contains('test')) {
        return "Quiz time! 🏆 Let's see what you know!\n\n"
            "**PYTHON MCQ SET — 5 Questions**\n\n"
            "**Q1.** What is the output of `print(type([]))`?\n"
            "A) `<class 'tuple'>`\n"
            "B) `<class 'list'>` ✅\n"
            "C) `<class 'array'>`\n"
            "D) `<class 'dict'>`\n\n"
            "**Q2.** Which method removes and returns the last element of a list?\n"
            "A) `remove()`\n"
            "B) `delete()`\n"
            "C) `pop()` ✅\n"
            "D) `discard()`\n\n"
            "**Q3.** What does `range(2, 10, 3)` produce?\n"
            "A) [2, 5, 8] ✅\n"
            "B) [2, 4, 6, 8]\n"
            "C) [2, 3, 10]\n"
            "D) [2, 5, 8, 11]\n\n"
            "**Q4.** Which is NOT a mutable type in Python?\n"
            "A) list\n"
            "B) dict\n"
            "C) set\n"
            "D) tuple ✅\n\n"
            "**Q5.** What is a lambda function?\n"
            "A) A class method\n"
            "B) An anonymous single-expression function ✅\n"
            "C) A recursive function\n"
            "D) A built-in function\n\n"
            "━━━━━━━━━━━━━━━\n"
            "Tell me your answers (e.g. `B C A D B`) and I'll score you!\n\n"
            "⭐ Perfect score = **+75 XP** + 🏅 **Quiz Master** badge!";
      }

      if (low.contains('weak') || low.contains('improve') || low.contains('area')) {
        return "Weak area analysis! 🔍\n\n"
            "Based on common learner patterns, most people struggle with:\n\n"
            "🔴 **High difficulty areas:**\n"
            "• Recursion & backtracking\n"
            "• Dynamic programming\n"
            "• Tree/graph traversals\n"
            "• Bit manipulation\n\n"
            "🟡 **Medium difficulty areas:**\n"
            "• Pointers & memory (C/C++)\n"
            "• Async/await & concurrency\n"
            "• OOP design patterns\n"
            "• Regular expressions\n\n"
            "🟢 **Usually easier:**\n"
            "• Basic syntax & data types\n"
            "• Loops & conditions\n"
            "• Simple functions\n\n"
            "**To find YOUR weak areas:**\n"
            "Take a 10-question quiz and I'll identify exactly where to focus.\n\n"
            "Want me to generate a diagnostic quiz? Type **'quiz me'**! 🎯\n\n"
            "⭐ Identifying weak areas = **+10 XP** (self-awareness bonus)!";
      }

      if (low.contains('tip') || low.contains('last minute') || low.contains('exam day')) {
        return "Last-minute exam tips! 🎯\n\n"
            "**The Night Before:**\n"
            "✅ Review notes (no new topics!)\n"
            "✅ Solve 2–3 familiar problems to build confidence\n"
            "✅ Sleep 7–8 hours minimum\n"
            "✅ Prepare everything (ID, pens, water)\n\n"
            "**Morning Of:**\n"
            "✅ Light breakfast\n"
            "✅ Quick 10-min review of key formulas\n"
            "✅ Arrive early, breathe deeply\n\n"
            "**During the Exam:**\n"
            "⏱️ Read all questions first (2 min)\n"
            "✅ Answer easy questions first\n"
            "🧠 If stuck: skip, come back later\n"
            "✏️ Show your working/steps\n"
            "🔍 Review with remaining time\n\n"
            "**For Coding Exams specifically:**\n"
            "• Test with edge cases: empty input, single element, negatives\n"
            "• Brute force first, then optimise\n"
            "• Comment your logic\n"
            "• Check off-by-one errors in loops\n\n"
            "You've got this! 💪🔥\n\n"
            "⭐ You're exam-ready = **+25 XP**!";
      }
    }

    // ── Chat Mode / General responses ─────────────────────────────────────

    if (low.contains('motivat') || low.contains('demotivat') || low.contains('give up') ||
        low.contains('tired') || low.contains('struggling')) {
      return "Hey, I hear you. It's completely normal to feel this way! 🤗\n\n"
          "Here's the truth about learning to code:\n\n"
          "🌊 **Everyone struggles.** Even senior engineers google basic syntax.\n"
          "📈 **Progress is not linear.** Plateaus are followed by breakthroughs.\n"
          "🧠 **Confusion = learning.** If it's easy, you're not growing.\n\n"
          "**Right now, try this:**\n"
          "• Take a 10-minute walk 🚶\n"
          "• Come back and solve just ONE tiny problem\n"
          "• Celebrate that small win\n\n"
          "Remember why you started. Every line of code you write makes you better.\n\n"
          "You've already made it further than most people who give up before starting. "
          "That makes you a coder already. 🏆\n\n"
          "Want a quick fun challenge to get back in flow? 😊\n\n"
          "⭐ Showing up today despite the struggle = **+50 XP** (Resilience bonus)!";
    }

    if (low.contains('career') || low.contains('job') || low.contains('interview')) {
      return "Career advice — let's plan your path! 🚀\n\n"
          "**Roadmap to your first tech job:**\n\n"
          "**Month 1–2: Foundation**\n"
          "• Pick one language (Python or JavaScript recommended)\n"
          "• Learn syntax, data structures, OOP\n"
          "• Solve 30 easy LeetCode problems\n\n"
          "**Month 3–4: Projects**\n"
          "• Build 2–3 portfolio projects\n"
          "• Push everything to GitHub\n"
          "• Write a README for each project\n\n"
          "**Month 5–6: Interview Prep**\n"
          "• Solve 50 medium LeetCode problems\n"
          "• Practice system design basics\n"
          "• Mock interviews with friends\n\n"
          "**Resume Tips:**\n"
          "• Quantify achievements (\"Reduced load time by 40%\")\n"
          "• List projects with GitHub links\n"
          "• Keep it to 1 page\n\n"
          "What stage are you at? I'll give more targeted advice! 🎯\n\n"
          "⭐ Career planning = **+20 XP**!";
    }

    if (low.contains('hello') || low.contains('hi') || low.contains('hey') || low.contains('sup')) {
      return "Hey hey! 👋 Great to see you!\n\n"
          "Ready to level up today? Here are some things we can do:\n\n"
          "💻 **Code Mode** — Fix bugs, get challenges, code review\n"
          "📚 **Study Mode** — Study plans, flashcards, Pomodoro sessions\n"
          "🏆 **Exam Mode** — MCQs, mock tests, last-minute tips\n\n"
          "Or just tell me what's on your mind — I'm here for it! 😊\n\n"
          "⭐ Showing up consistently = **🔥 Streak bonus XP**!";
    }

    if (low.contains('daily') || low.contains('mission') || low.contains('today')) {
      return "Here's your **Daily Mission** for today! 🎯\n\n"
          "━━━ DAILY MISSIONS ━━━\n\n"
          "🟢 **Easy** (+30 XP)\n"
          "Write a function that reverses a string without using built-in reverse.\n\n"
          "🟡 **Medium** (+60 XP)\n"
          "Implement a stack using only queues.\n\n"
          "🔴 **Hard** (+120 XP)\n"
          "Find the longest substring without repeating characters.\n\n"
          "━━━ BONUS MISSIONS ━━━\n\n"
          "📖 Read about Binary Search Trees (+20 XP)\n"
          "✍️ Write revision notes on OOP (+15 XP)\n"
          "🗣️ Explain a concept to someone (+25 XP)\n\n"
          "Complete all missions for **🔥 250 XP** + streak bonus!\n\n"
          "Which one do you want to tackle first?";
    }

    // Default general response
    return "Great question! Let me help you with that. 🤔\n\n"
        "Here's what I'd suggest:\n\n"
        "**Start with the fundamentals:**\n"
        "Understanding the core concept deeply is more valuable than rushing to advanced topics. "
        "Once the foundation is solid, everything else clicks faster.\n\n"
        "**Practice > Passive learning:**\n"
        "Reading about code is 10% as effective as writing it. Even a small 10-line "
        "exercise beats an hour of watching tutorials.\n\n"
        "**Build something real:**\n"
        "The fastest way to level up is building a project that excites you. "
        "Pick something you'd actually use.\n\n"
        "Want me to go deeper on any specific part? "
        "Or switch to **Code Mode** for hands-on practice? 🚀\n\n"
        "⭐ Asking good questions = **+5 XP** (Curious Learner bonus)!";
  }

  // ── XP from response ───────────────────────────────────────────────────────

  int _extractXp(String response) {
    final match = RegExp(r'\+(\d+)\s*XP').firstMatch(response);
    if (match != null) return int.tryParse(match.group(1) ?? '0') ?? 0;
    return 0;
  }

  // ── Send message ────────────────────────────────────────────────────────────

  Future<void> _send(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(
        content: text.trim(),
        isBot: false,
        timestamp: DateTime.now(),
        mode: _mode,
      ));
      _isTyping = true;
      _inputController.clear();
    });
    _scrollToBottom();

    final response = await _callOpenAI(text.trim());
    final xp = _extractXp(response);

    setState(() {
      _isTyping = false;
      _messages.add(_ChatMessage(
        content: response,
        isBot: true,
        timestamp: DateTime.now(),
        mode: _mode,
        xpAwarded: xp > 0 ? xp : null,
      ));
      if (xp > 0) _sessionXp += xp;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ── Mode switch ─────────────────────────────────────────────────────────────

  void _switchMode(MentorMode newMode) {
    if (newMode == _mode) return;
    setState(() {
      _mode = newMode;
      _messages.add(_ChatMessage(
        content: switch (newMode) {
          MentorMode.chat  => "Switched to **Chat Mode** 💬\nLet's talk naturally — ask me anything or just tell me how you're doing!",
          MentorMode.code  => "Switched to **Coding Mode** 💻\nPaste your code, describe a bug, or ask for a challenge. I'll give hints before solutions!",
          MentorMode.study => "Switched to **Study Mode** 📚\nWant a study plan, flashcards, Pomodoro session, or revision notes? Just ask!",
          MentorMode.exam  => "Switched to **Exam Mode** 🏆\nI'll quiz you, generate mock tests, identify weak areas, and give exam tips. Ready?",
        },
        isBot: true,
        timestamp: DateTime.now(),
        mode: newMode,
      ));
    });
    _scrollToBottom();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _ModeSelector(current: _mode, onSelect: _switchMode),
          _QuickPromptsBar(prompts: _mode.quickPrompts, onTap: _send, modeColor: _mode.color),
          Expanded(child: _buildMessageList()),
          _InputBar(
            controller: _inputController,
            onSend: _send,
            modeColor: _mode.color,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: Row(
        children: [
          // Animated avatar
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [_mode.color, _mode.color.withOpacity(0.5)],
              ),
              boxShadow: [
                BoxShadow(
                  color: _mode.color.withOpacity(0.5),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Center(
              child: Text(
                _mode.emoji,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .shimmer(duration: 2000.ms, color: _mode.color.withOpacity(0.4)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ALEX AI MENTOR',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: context.cqTextPrimary,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 6, height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.neonGreen,
                      boxShadow: [BoxShadow(color: AppColors.neonGreen, blurRadius: 4)],
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true))
                      .fade(begin: 0.3, end: 1.0, duration: 800.ms),
                  const SizedBox(width: 4),
                  Text(
                    'Online • ${_mode.label} Mode',
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 11,
                      color: _mode.color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Session XP counter
        Container(
          margin: const EdgeInsets.only(right: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.neonYellow.withOpacity(0.15),
            border: Border.all(color: AppColors.neonYellow.withOpacity(0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⭐', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
              Text(
                '+$_sessionXp',
                style: const TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 11,
                  color: AppColors.neonYellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Clear chat
        IconButton(
          icon: Icon(Icons.refresh_rounded, color: context.cqTextSecondary, size: 20),
          onPressed: () => setState(() {
            _messages.clear();
            _apiHistory.clear();
            _sessionXp = 0;
            _addWelcome();
          }),
        ),
      ],
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, i) {
        if (i == _messages.length) {
          return _TypingIndicator(color: _mode.color);
        }
        return _MessageBubble(message: _messages[i])
            .animate()
            .fadeIn(duration: 280.ms)
            .slideY(begin: 0.15, curve: Curves.easeOut);
      },
    );
  }
}

// ─── Mode Selector ────────────────────────────────────────────────────────────

class _ModeSelector extends StatelessWidget {
  final MentorMode current;
  final ValueChanged<MentorMode> onSelect;

  const _ModeSelector({required this.current, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.cqBgSecondary,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: MentorMode.values.map((mode) {
          final isActive = mode == current;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(mode),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isActive
                      ? mode.color.withOpacity(0.2)
                      : Colors.transparent,
                  border: Border.all(
                    color: isActive
                        ? mode.color.withOpacity(0.7)
                        : context.cqSurface,
                    width: isActive ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(mode.emoji, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(
                      mode.label,
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: isActive ? mode.color : context.cqTextMuted,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Quick Prompts Bar ────────────────────────────────────────────────────────

class _QuickPromptsBar extends StatelessWidget {
  final List<String> prompts;
  final ValueChanged<String> onTap;
  final Color modeColor;

  const _QuickPromptsBar({
    required this.prompts,
    required this.onTap,
    required this.modeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      color: context.cqBgSecondary,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
        itemCount: prompts.length,
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => onTap(prompts[i].replaceAll(RegExp(r'^[\p{Emoji}]+\s*', unicode: true), '').trim()),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: modeColor.withOpacity(0.08),
              border: Border.all(color: modeColor.withOpacity(0.3)),
            ),
            child: Text(
              prompts[i],
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 12,
                color: context.cqTextPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Message Bubble ───────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment:
            message.isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.isBot) ...[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [message.mode.color, message.mode.color.withOpacity(0.5)],
                ),
              ),
              child: Center(
                child: Text(message.mode.emoji, style: const TextStyle(fontSize: 14)),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isBot
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(message.isBot ? 4 : 18),
                      topRight: Radius.circular(message.isBot ? 18 : 4),
                      bottomLeft: const Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                    gradient: message.isBot ? null : AppColors.cyberpunkGradient,
                    color: message.isBot ? context.cqCard : null,
                    border: message.isBot
                        ? Border.all(
                            color: message.mode.color.withOpacity(0.2),
                          )
                        : null,
                  ),
                  child: _FormattedText(
                    text: message.content,
                    isBot: message.isBot,
                  ),
                ),
                // XP badge
                if (message.isBot && message.xpAwarded != null && message.xpAwarded! > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.neonYellow.withOpacity(0.15),
                        border: Border.all(color: AppColors.neonYellow.withOpacity(0.4)),
                      ),
                      child: Text(
                        '⭐ +${message.xpAwarded} XP available',
                        style: const TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 9,
                          color: AppColors.neonYellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (!message.isBot) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

// ─── Formatted text (bold, code blocks) ──────────────────────────────────────

class _FormattedText extends StatelessWidget {
  final String text;
  final bool isBot;

  const _FormattedText({required this.text, required this.isBot});

  @override
  Widget build(BuildContext context) {
    // Split by code blocks first
    final parts = text.split(RegExp(r'```[a-z]*\n?'));
    final widgets = <Widget>[];
    bool inCode = false;

    for (final part in parts) {
      if (part.trim().isEmpty) {
        inCode = !inCode;
        continue;
      }
      if (inCode) {
        widgets.add(_CodeBlock(code: part.trimRight()));
      } else {
        widgets.add(_RichLine(text: part, isBot: isBot));
      }
      inCode = !inCode;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}

class _RichLine extends StatelessWidget {
  final String text;
  final bool isBot;
  const _RichLine({required this.text, required this.isBot});

  @override
  Widget build(BuildContext context) {
    // Simple bold markdown: **text**
    final spans = <TextSpan>[];
    final parts = text.split('**');
    for (int i = 0; i < parts.length; i++) {
      spans.add(TextSpan(
        text: parts[i],
        style: TextStyle(
          fontWeight: i.isOdd ? FontWeight.bold : FontWeight.normal,
          color: isBot ? context.cqTextPrimary : Colors.white,
        ),
      ));
    }
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'Rajdhani',
          fontSize: 14,
          height: 1.55,
          color: isBot ? context.cqTextPrimary : Colors.white,
        ),
        children: spans,
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String code;
  const _CodeBlock({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF0D1117),
        border: Border.all(color: AppColors.neonCyan.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.neonCyan.withOpacity(0.15)),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  '▶ CODE',
                  style: TextStyle(
                    fontFamily: 'Share Tech Mono',
                    fontSize: 9,
                    color: AppColors.neonCyan,
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Clipboard.setData(ClipboardData(text: code)),
                  child: Icon(Icons.copy_rounded, color: context.cqTextMuted, size: 14),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              code,
              style: const TextStyle(
                fontFamily: 'Share Tech Mono',
                fontSize: 12,
                color: Color(0xFFE6EDF3),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Typing Indicator ─────────────────────────────────────────────────────────

class _TypingIndicator extends StatelessWidget {
  final Color color;
  const _TypingIndicator({required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.5)],
              ),
            ),
            child: const Center(child: Text('🤖', style: TextStyle(fontSize: 14))),
          ),
          const SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: context.cqCard,
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return Container(
                  margin: EdgeInsets.only(right: i < 2 ? 5 : 0),
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                )
                    .animate(
                      delay: Duration(milliseconds: i * 180),
                      onPlay: (c) => c.repeat(reverse: true),
                    )
                    .fade(begin: 0.2, end: 1.0, duration: 380.ms)
                    .scale(begin: const Offset(0.7, 0.7), end: const Offset(1.0, 1.0));
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Input Bar ────────────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSend;
  final Color modeColor;

  const _InputBar({
    required this.controller,
    required this.onSend,
    required this.modeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16, 10, 16, MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: BoxDecoration(
        color: context.cqBgSecondary,
        border: Border(
          top: BorderSide(color: modeColor.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                color: context.cqCard,
                border: Border.all(color: modeColor.withOpacity(0.3)),
              ),
              child: TextField(
                controller: controller,
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: onSend,
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 15,
                  color: context.cqTextPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Ask ALEX anything...',
                  hintStyle: TextStyle(
                    color: context.cqTextMuted,
                    fontFamily: 'Rajdhani',
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => onSend(controller.text),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [modeColor, modeColor.withOpacity(0.6)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: modeColor.withOpacity(0.4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
