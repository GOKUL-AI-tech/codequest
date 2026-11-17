// ══════════════════════════════════════════════════════════════════════════════
// LESSON CONTENT DATABASE
// Local content for all 6 languages with unique concepts per lesson.
// Used as the primary content source for the lesson screen.
// ══════════════════════════════════════════════════════════════════════════════

class LessonSection {
  final String title;
  final String text;
  final String? code;
  final String? language; // for syntax highlighting
  final String? tipTitle;
  final String? tipBody;
  final List<String>? rules;
  final List<Map<String, dynamic>>? typeGrid; // [{type, example, color}]

  const LessonSection({
    required this.title,
    required this.text,
    this.code,
    this.language,
    this.tipTitle,
    this.tipBody,
    this.rules,
    this.typeGrid,
  });
}

class LessonContent {
  final String lessonKey;   // e.g. 'python_0'
  final String languageId;
  final String languageEmoji;
  final String title;
  final String subtitle;
  final int xpReward;
  final int coinReward;
  final int estimatedMinutes;
  final List<LessonSection> sections;
  final String voiceSummary; // read aloud on "Read" button tap

  const LessonContent({
    required this.lessonKey,
    required this.languageId,
    required this.languageEmoji,
    required this.title,
    required this.subtitle,
    required this.xpReward,
    required this.coinReward,
    required this.estimatedMinutes,
    required this.sections,
    required this.voiceSummary,
  });
}

// ─── Database ─────────────────────────────────────────────────────────────────

class LessonContentDb {
  static LessonContent? getByKey(String key) => _db[key];

  /// Get lessons for a language in order
  static List<LessonContent> forLanguage(String languageId) =>
      _db.values.where((l) => l.languageId == languageId).toList();

  /// Get lesson by index for a language
  static LessonContent? getByIndex(String languageId, int index) {
    final list = forLanguage(languageId);
    if (index < 0 || index >= list.length) return null;
    return list[index];
  }

  /// Get existing lesson or generate a structured language-aware lesson fallback
  static LessonContent getOrGenerate({
    required String lessonId,
    required String languageId,
    int? orderIndex,
    String? title,
    String? subtitle,
  }) {
    final existing = getByKey(lessonId);
    if (existing != null) return existing;

    final langList = forLanguage(languageId);
    if (orderIndex != null && orderIndex > 0 && langList.isNotEmpty) {
      final idx = (orderIndex - 1).clamp(0, langList.length - 1);
      return langList[idx];
    } else if (langList.isNotEmpty) {
      return langList.first;
    }

    final emoji = switch (languageId) {
      'python' => '🐍',
      'javascript' => '⚡',
      'dart' => '🎯',
      'java' => '☕',
      'cpp' => '⚙️',
      'c' => '🔧',
      _ => '💻',
    };

    final langName = switch (languageId) {
      'python' => 'Python',
      'javascript' => 'JavaScript',
      'dart' => 'Dart',
      'java' => 'Java',
      'cpp' => 'C++',
      'c' => 'C',
      _ => languageId.toUpperCase(),
    };

    final cleanTitle = title ?? '$langName Mastery';
    final cleanSubtitle = subtitle ?? 'Essential concepts in $langName';

    return LessonContent(
      lessonKey: lessonId,
      languageId: languageId,
      languageEmoji: emoji,
      title: cleanTitle,
      subtitle: cleanSubtitle,
      xpReward: 50,
      coinReward: 10,
      estimatedMinutes: 12,
      voiceSummary:
          'In this lesson, you will master $cleanTitle in $langName. Follow the theory, study the example code, and complete the practice exercises.',
      sections: [
        LessonSection(
          title: 'Understanding $cleanTitle',
          text:
              'This lesson explores the core fundamentals of $cleanTitle in $langName. Writing efficient, clean code requires understanding these foundational building blocks.',
          code: switch (languageId) {
            'python' =>
              '# $cleanTitle in Python\ndef main():\n    print("Mastering $cleanTitle")\n\nmain()',
            'javascript' =>
              '// $cleanTitle in JavaScript\nfunction main() {\n  console.log("Mastering $cleanTitle");\n}\nmain();',
            'dart' =>
              '// $cleanTitle in Dart\nvoid main() {\n  print("Mastering $cleanTitle");\n}',
            'java' =>
              '// $cleanTitle in Java\npublic class Main {\n    public static void main(String[] args) {\n        System.out.println("Mastering $cleanTitle");\n    }\n}',
            'cpp' =>
              '// $cleanTitle in C++\n#include <iostream>\nint main() {\n    std::cout << "Mastering $cleanTitle" << std::endl;\n    return 0;\n}',
            'c' =>
              '// $cleanTitle in C\n#include <stdio.h>\nint main() {\n    printf("Mastering $cleanTitle\\n");\n    return 0;\n}',
            _ => '// $cleanTitle\n',
          },
          language: languageId,
        ),
        LessonSection(
          title: 'Core Principles',
          text: 'Key best practices for $cleanTitle:',
          rules: [
            'Follow idiomatic coding conventions for $langName',
            'Ensure type safety and handle edge cases gracefully',
            'Structure your logic cleanly into reusable components',
          ],
        ),
        const LessonSection(
          title: 'Pro Tip',
          text: '',
          tipTitle: 'Best Practice',
          tipBody:
              'Always test edge cases and write modular functions for cleaner, more maintainable code.',
        ),
      ],
    );
  }

  // ── Python ────────────────────────────────────────────────────────────────

  static final Map<String, LessonContent> _db = {

    // ── Python ──────────────────────────────────────────────────────────────

    'python_0': LessonContent(
      lessonKey: 'python_0', languageId: 'python',
      languageEmoji: '🐍', title: 'Variables & Data Types',
      subtitle: 'Store and name your data', xpReward: 50, coinReward: 10, estimatedMinutes: 10,
      voiceSummary: 'In Python, variables are containers for storing data. You create them by simply assigning a value. Python supports integers, floats, strings, booleans, lists, and dictionaries. The type function tells you what type a variable is.',
      sections: [
        LessonSection(
          title: 'What is a Variable?',
          text: 'A variable is a named container that holds a value. In Python you create one simply by assigning a value — no declaration keyword needed.',
          code: '# Create variables\nage = 25\nname = "CodeQuest Hero"\nheight = 5.9\nis_awesome = True\n\nprint(age)          # 25\nprint(type(name))   # <class \'str\'>',
          language: 'python',
        ),
        LessonSection(
          title: 'Core Data Types',
          text: 'Python has several built-in data types:',
          typeGrid: [
            {'type': 'int', 'example': '42', 'colorHex': 0xFF00F5FF},
            {'type': 'float', 'example': '3.14', 'colorHex': 0xFFBF00FF},
            {'type': 'str', 'example': '"hi"', 'colorHex': 0xFF39FF14},
            {'type': 'bool', 'example': 'True', 'colorHex': 0xFFFF6B00},
            {'type': 'list', 'example': '[1,2]', 'colorHex': 0xFFFF006E},
            {'type': 'dict', 'example': '{k:v}', 'colorHex': 0xFFFFE600},
          ],
        ),
        LessonSection(
          title: 'Key Rules',
          text: 'Follow these rules when naming variables:',
          rules: [
            'Names are case-sensitive: age ≠ Age',
            'Must start with a letter or underscore',
            'Cannot be a Python keyword (if, for, while…)',
            'Use snake_case for multi-word names: user_score',
          ],
        ),
        LessonSection(
          title: 'Pro Tip',
          text: '',
          tipTitle: 'Dynamic Typing',
          tipBody: 'Python is dynamically typed — you can reassign x = 5 then x = "hello" freely. This is called duck typing.',
        ),
      ],
    ),

    'python_1': LessonContent(
      lessonKey: 'python_1', languageId: 'python',
      languageEmoji: '🐍', title: 'Control Flow: if / elif / else',
      subtitle: 'Make decisions in your code', xpReward: 50, coinReward: 10, estimatedMinutes: 12,
      voiceSummary: 'Control flow lets your program make decisions. The if statement checks a condition. If it is true, that block runs. You can add elif for more conditions, and else for when nothing matches.',
      sections: [
        LessonSection(
          title: 'The if Statement',
          text: 'The if statement runs a block only when its condition is True. Python uses indentation (4 spaces) instead of curly braces.',
          code: 'score = 85\n\nif score >= 90:\n    print("Grade: A")\nelif score >= 80:\n    print("Grade: B")   # ← this runs\nelif score >= 70:\n    print("Grade: C")\nelse:\n    print("Grade: F")',
          language: 'python',
        ),
        LessonSection(
          title: 'Comparison Operators',
          text: 'These operators return True or False:',
          rules: [
            '== equal to',
            '!= not equal to',
            '> greater than, < less than',
            '>= greater or equal, <= less or equal',
            'and / or / not — logical operators',
          ],
        ),
        LessonSection(
          title: 'Nested Conditions',
          text: 'You can nest if statements inside other blocks.',
          code: 'age = 20\nhas_id = True\n\nif age >= 18:\n    if has_id:\n        print("Entry allowed")\n    else:\n        print("Need ID")\nelse:\n    print("Too young")',
          language: 'python',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'One-Line Ternary',
          tipBody: 'result = "pass" if score >= 50 else "fail" — a compact if-else in a single line.',
        ),
      ],
    ),

    'python_2': LessonContent(
      lessonKey: 'python_2', languageId: 'python',
      languageEmoji: '🐍', title: 'Lists & Loops',
      subtitle: 'Work with collections of data', xpReward: 60, coinReward: 12, estimatedMinutes: 15,
      voiceSummary: 'Lists store multiple items in a single variable. You can loop over them with a for loop. Python also has while loops for repeating code until a condition is false.',
      sections: [
        LessonSection(
          title: 'Creating Lists',
          text: 'A list holds multiple values in order. Lists can mix types and are mutable (changeable).',
          code: 'fruits = ["apple", "banana", "cherry"]\nnumbers = [1, 2, 3, 4, 5]\nmixed = [1, "hello", True, 3.14]\n\nprint(fruits[0])    # apple\nprint(len(fruits))  # 3\nfruits.append("mango")\nfruits.remove("banana")',
          language: 'python',
        ),
        LessonSection(
          title: 'For Loops',
          text: 'Iterate over every item in a list:',
          code: 'scores = [95, 87, 72, 61, 88]\n\nfor score in scores:\n    print(score)\n\n# With index\nfor i, score in enumerate(scores):\n    print(f"Player {i+1}: {score}")\n\n# Range loop\nfor i in range(5):\n    print(i)   # 0 1 2 3 4',
          language: 'python',
        ),
        LessonSection(
          title: 'While Loops',
          text: 'Run a block while a condition stays True:',
          code: 'lives = 3\n\nwhile lives > 0:\n    print(f"Lives left: {lives}")\n    lives -= 1\n\nprint("Game Over")',
          language: 'python',
        ),
        LessonSection(
          title: 'List Comprehension', text: '',
          tipTitle: 'Compact List Creation',
          tipBody: 'squares = [x**2 for x in range(10)] creates [0,1,4,9,16…] in one line — faster and more Pythonic than a for loop.',
        ),
      ],
    ),

    'python_3': LessonContent(
      lessonKey: 'python_3', languageId: 'python',
      languageEmoji: '🐍', title: 'Functions',
      subtitle: 'Reusable blocks of code', xpReward: 60, coinReward: 12, estimatedMinutes: 14,
      voiceSummary: 'Functions let you write code once and use it many times. You define a function with the def keyword, give it a name, optional parameters, and a body. Use return to send a value back.',
      sections: [
        LessonSection(
          title: 'Defining a Function',
          text: 'Use def to create a function. Call it by name with parentheses.',
          code: 'def greet(name):\n    return f"Hello, {name}! Welcome to CodeQuest."\n\nmessage = greet("Alex")\nprint(message)   # Hello, Alex! Welcome to CodeQuest.',
          language: 'python',
        ),
        LessonSection(
          title: 'Default & Keyword Args',
          text: 'Parameters can have defaults and be passed by name:',
          code: 'def power(base, exponent=2):\n    return base ** exponent\n\nprint(power(3))       # 9  (uses default)\nprint(power(2, 10))   # 1024\nprint(power(exponent=3, base=4))  # 64',
          language: 'python',
        ),
        LessonSection(
          title: 'Lambda Functions',
          text: 'Short anonymous functions for simple operations:',
          code: 'double = lambda x: x * 2\nadd = lambda a, b: a + b\n\nprint(double(5))    # 10\nprint(add(3, 4))    # 7\n\n# Common use: sorting\nplayers = [("Alex", 95), ("Sam", 87), ("Jo", 99)]\nplayers.sort(key=lambda p: p[1], reverse=True)',
          language: 'python',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: '*args and **kwargs',
          tipBody: 'def f(*args, **kwargs) lets you accept any number of positional and keyword arguments — great for flexible APIs.',
        ),
      ],
    ),

    'python_4': LessonContent(
      lessonKey: 'python_4', languageId: 'python',
      languageEmoji: '🐍', title: 'Dictionaries & Sets',
      subtitle: 'Key-value storage and unique collections', xpReward: 70, coinReward: 15, estimatedMinutes: 14,
      voiceSummary: 'A dictionary stores data as key-value pairs, like a real dictionary with words and definitions. Sets store unique values with no duplicates. Both are very fast for lookups.',
      sections: [
        LessonSection(
          title: 'Creating Dictionaries',
          text: 'Dicts map keys to values. Keys must be unique and immutable.',
          code: 'player = {\n    "name": "Alex",\n    "level": 12,\n    "xp": 4500,\n    "languages": ["Python", "JS"]\n}\n\nprint(player["name"])        # Alex\nplayer["xp"] += 100          # update\nplayer["coins"] = 250        # add new key\ndel player["languages"]      # delete key',
          language: 'python',
        ),
        LessonSection(
          title: 'Looping Dictionaries',
          text: 'Iterate over keys, values, or both:',
          code: 'scores = {"Alice": 95, "Bob": 87, "Carol": 92}\n\nfor name, score in scores.items():\n    print(f"{name}: {score}")\n\n# Get with default\nprint(scores.get("Dave", 0))  # 0 (not found)',
          language: 'python',
        ),
        LessonSection(
          title: 'Sets',
          text: 'Sets hold unique items and support fast membership checks:',
          code: 'languages = {"Python", "JS", "Python", "Dart"}\nprint(languages)   # {"Python", "JS", "Dart"}\n\n# Set operations\na = {1, 2, 3, 4}\nb = {3, 4, 5, 6}\nprint(a & b)  # intersection {3, 4}\nprint(a | b)  # union {1,2,3,4,5,6}\nprint(a - b)  # difference {1, 2}',
          language: 'python',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'Dict Comprehension',
          tipBody: 'squared = {x: x**2 for x in range(5)} creates {0:0, 1:1, 2:4, 3:9, 4:16} in one line.',
        ),
      ],
    ),

    // ── JavaScript ──────────────────────────────────────────────────────────

    'javascript_0': LessonContent(
      lessonKey: 'javascript_0', languageId: 'javascript',
      languageEmoji: '⚡', title: 'Variables: let, const & var',
      subtitle: 'The three ways to store data in JS', xpReward: 50, coinReward: 10, estimatedMinutes: 10,
      voiceSummary: 'JavaScript has three keywords for creating variables: var, let, and const. Use const when the value will not change, let when it will. Avoid var in modern JavaScript.',
      sections: [
        LessonSection(
          title: 'let and const',
          text: 'Modern JavaScript uses let for mutable values and const for constants. Always prefer these over var.',
          code: "const appName = 'CodeQuest';   // can't reassign\nlet score = 0;                 // can reassign\n\nscore = 100;      // ✓ OK\n// appName = 'X'; // ✗ TypeError!\n\nlet x;            // undefined until assigned\nconsole.log(x);   // undefined",
          language: 'javascript',
        ),
        LessonSection(
          title: 'Template Literals',
          text: 'Use backticks for string interpolation — much cleaner than concatenation:',
          code: "const name = 'Alex';\nconst level = 12;\n\n// Old way\nconsole.log('Hello ' + name + ', level ' + level);\n\n// Modern way\nconsole.log(`Hello \${name}, level \${level}`);\n\n// Multi-line\nconst msg = `\n  Player: \${name}\n  Level:  \${level}\n`;",
          language: 'javascript',
        ),
        LessonSection(
          title: 'Data Types',
          text: 'JavaScript has 7 primitive types:',
          rules: [
            'number — both integers and floats: 42, 3.14',
            'string — text: "hello", \'world\', `template`',
            'boolean — true or false',
            'undefined — declared but not assigned',
            'null — intentional absence of value',
            'bigint — very large integers: 9007199254740993n',
            'symbol — unique identifiers',
          ],
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'typeof Operator',
          tipBody: 'typeof 42 → "number", typeof "hi" → "string". Beware: typeof null → "object" — a famous JS bug from 1995!',
        ),
      ],
    ),

    'javascript_1': LessonContent(
      lessonKey: 'javascript_1', languageId: 'javascript',
      languageEmoji: '⚡', title: 'Functions & Arrow Functions',
      subtitle: 'The many ways to write functions in JS', xpReward: 50, coinReward: 10, estimatedMinutes: 12,
      voiceSummary: 'JavaScript functions can be written in multiple ways. Traditional functions use the function keyword. Arrow functions use the fat arrow syntax and are shorter. Both do the same thing but have different behaviour for the this keyword.',
      sections: [
        LessonSection(
          title: 'Function Declaration',
          text: 'Traditional function — hoisted to the top of its scope.',
          code: "function greet(name) {\n  return `Hello, \${name}!`;\n}\n\nconsole.log(greet('Alex'));   // Hello, Alex!\nconsole.log(greet());         // Hello, undefined!",
          language: 'javascript',
        ),
        LessonSection(
          title: 'Arrow Functions',
          text: 'Shorter syntax — great for callbacks and array methods:',
          code: "// One-liner (implicit return)\nconst double = x => x * 2;\n\n// Multi-param\nconst add = (a, b) => a + b;\n\n// Multi-line (needs return)\nconst power = (base, exp) => {\n  let result = 1;\n  for (let i = 0; i < exp; i++) result *= base;\n  return result;\n};\n\nconsole.log(double(5));     // 10\nconsole.log(power(2, 8));   // 256",
          language: 'javascript',
        ),
        LessonSection(
          title: 'Default Parameters',
          text: 'Set fallback values for missing arguments:',
          code: "const greetPlayer = (name = 'Player', level = 1) => {\n  return `Welcome \${name}, Level \${level}`;\n};\n\nconsole.log(greetPlayer('Alex', 12));  // Welcome Alex, Level 12\nconsole.log(greetPlayer());            // Welcome Player, Level 1",
          language: 'javascript',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'Arrow vs Regular this',
          tipBody: 'Arrow functions inherit this from the surrounding scope. Regular functions have their own this. Use arrows for callbacks inside classes to avoid binding issues.',
        ),
      ],
    ),

    'javascript_2': LessonContent(
      lessonKey: 'javascript_2', languageId: 'javascript',
      languageEmoji: '⚡', title: 'Arrays & Array Methods',
      subtitle: 'The most powerful feature of JavaScript', xpReward: 60, coinReward: 12, estimatedMinutes: 15,
      voiceSummary: 'JavaScript arrays come with powerful built-in methods. Map transforms each element. Filter keeps elements that match a condition. Reduce combines all elements into one value. These three methods replace most traditional for loops.',
      sections: [
        LessonSection(
          title: 'Array Basics',
          text: 'Arrays hold ordered lists. They are zero-indexed and dynamic.',
          code: "const players = ['Alex', 'Sam', 'Jo'];\nplayers.push('Max');        // add to end\nplayers.unshift('Zara');    // add to front\nplayers.pop();              // remove from end\nplayers.splice(1, 1);       // remove 1 item at index 1\n\nconsole.log(players.length);  // count\nconsole.log(players[0]);      // first item",
          language: 'javascript',
        ),
        LessonSection(
          title: 'map, filter, reduce',
          text: 'The three most important array methods — learn them deeply:',
          code: "const scores = [95, 42, 87, 61, 78, 55];\n\n// map: transform each item\nconst doubled = scores.map(s => s * 2);\n\n// filter: keep items matching condition  \nconst passing = scores.filter(s => s >= 60);\n// [95, 87, 61, 78]\n\n// reduce: combine into single value\nconst total = scores.reduce((sum, s) => sum + s, 0);\nconst average = total / scores.length;  // 69.67",
          language: 'javascript',
        ),
        LessonSection(
          title: 'Spread & Destructuring',
          text: 'Modern JS shortcuts for working with arrays:',
          code: "const a = [1, 2, 3];\nconst b = [4, 5, 6];\nconst combined = [...a, ...b]; // [1,2,3,4,5,6]\n\n// Destructuring\nconst [first, second, ...rest] = combined;\nconsole.log(first);   // 1\nconsole.log(rest);    // [3,4,5,6]",
          language: 'javascript',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'find vs filter',
          tipBody: 'find() returns the FIRST matching element. filter() returns ALL matching elements as a new array. Use find() when you expect one result.',
        ),
      ],
    ),

    'javascript_3': LessonContent(
      lessonKey: 'javascript_3', languageId: 'javascript',
      languageEmoji: '⚡', title: 'Promises & Async/Await',
      subtitle: 'Handle asynchronous operations cleanly', xpReward: 80, coinReward: 20, estimatedMinutes: 18,
      voiceSummary: 'JavaScript is single-threaded but handles async operations using Promises. A promise represents a future value. Async and await let you write async code that reads like synchronous code, making it much easier to understand.',
      sections: [
        LessonSection(
          title: 'What is Async?',
          text: 'JS runs one thing at a time, but can start an operation (like a network request) and continue running other code while waiting for it.',
          code: "console.log('1 - Start');\n\nsetTimeout(() => {\n  console.log('2 - After 2 seconds');\n}, 2000);\n\nconsole.log('3 - End');\n\n// Output order:\n// 1 - Start\n// 3 - End\n// 2 - After 2 seconds",
          language: 'javascript',
        ),
        LessonSection(
          title: 'Promises',
          text: 'A Promise is an object that will resolve or reject in the future:',
          code: "const fetchScore = () => new Promise((resolve, reject) => {\n  setTimeout(() => resolve(95), 1000);\n});\n\nfetchScore()\n  .then(score => console.log(`Score: \${score}`))\n  .catch(err => console.error(err))\n  .finally(() => console.log('Done'));",
          language: 'javascript',
        ),
        LessonSection(
          title: 'Async / Await',
          text: 'await pauses execution until a Promise resolves — much more readable:',
          code: "async function loadPlayerData(userId) {\n  try {\n    const response = await fetch(`/api/players/\${userId}`);\n    const player = await response.json();\n    console.log(player.name, player.level);\n    return player;\n  } catch (error) {\n    console.error('Failed:', error);\n  }\n}",
          language: 'javascript',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'Promise.all for Parallel Calls',
          tipBody: 'const [a, b] = await Promise.all([fetchA(), fetchB()]) runs both requests simultaneously — faster than awaiting them one by one.',
        ),
      ],
    ),

    // ── Dart ────────────────────────────────────────────────────────────────

    'dart_0': LessonContent(
      lessonKey: 'dart_0', languageId: 'dart',
      languageEmoji: '🎯', title: 'Variables & Null Safety',
      subtitle: 'Dart\'s type system eliminates null crashes', xpReward: 50, coinReward: 10, estimatedMinutes: 12,
      voiceSummary: 'Dart is a strongly typed language developed by Google. It has null safety, which means variables cannot be null by default. You must explicitly mark a variable as nullable with a question mark. This prevents the billion dollar mistake of null pointer errors.',
      sections: [
        LessonSection(
          title: 'Declaring Variables',
          text: 'Dart is statically typed. Use var for inferred types or write the type explicitly.',
          code: "String name = 'CodeQuest';  // explicit type\nint level = 12;             // integer\ndouble xp = 4500.5;         // decimal\nbool isActive = true;       // boolean\n\nvar score = 95;    // inferred as int\nfinal pi = 3.14;   // can't reassign\nconst max = 100;   // compile-time constant",
          language: 'dart',
        ),
        LessonSection(
          title: 'Null Safety',
          text: 'By default variables cannot be null. Add ? to allow null:',
          code: "String name = 'Alex';   // non-nullable\n// name = null;         // ✗ compile error!\n\nString? nickname;       // nullable (can be null)\nnickname = 'Coder';     // OK\nnickname = null;        // OK\n\n// Null-aware operators\nprint(nickname ?? 'No nickname');   // use default if null\nnickname ??= 'Default';             // assign if null\nprint(nickname?.length);            // safe access",
          language: 'dart',
        ),
        LessonSection(
          title: 'Late Variables',
          text: 'Use late for variables initialised after declaration:',
          code: "class GameEngine {\n  late String playerName;  // assigned later\n  \n  void init(String name) {\n    playerName = name;  // must set before use\n  }\n  \n  void run() {\n    print('Playing as \$playerName');  // safe\n  }\n}",
          language: 'dart',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'final vs const',
          tipBody: 'final means assigned once at runtime. const means known at compile time and is deeply immutable. Use const for literals like colors and strings.',
        ),
      ],
    ),

    'dart_1': LessonContent(
      lessonKey: 'dart_1', languageId: 'dart',
      languageEmoji: '🎯', title: 'Functions & Arrow Syntax',
      subtitle: 'Dart\'s concise function syntax', xpReward: 50, coinReward: 10, estimatedMinutes: 12,
      voiceSummary: 'Dart functions are similar to other languages but with strong typing. You can use arrow syntax for single-expression functions. Dart also supports optional positional and named parameters, making APIs very expressive.',
      sections: [
        LessonSection(
          title: 'Function Basics',
          text: 'Dart functions have explicit return types and parameter types.',
          code: "// Standard function\nint add(int a, int b) {\n  return a + b;\n}\n\n// Arrow function (single expression)\nint multiply(int a, int b) => a * b;\n\n// Void return\nvoid printWelcome(String name) {\n  print('Welcome, \$name!');\n}\n\nprint(add(3, 4));        // 7\nprint(multiply(5, 6));   // 30",
          language: 'dart',
        ),
        LessonSection(
          title: 'Named Parameters',
          text: 'Named parameters make function calls self-documenting:',
          code: "// {} makes them named and optional\nvoid createPlayer({\n  required String name,\n  int level = 1,\n  String? character,\n}) {\n  print('\$name | Level \$level | \${character ?? \"none\"}');\n}\n\n// Call with names (order doesn't matter)\ncreatePlayer(name: 'Alex', level: 12);\ncreatePlayer(character: 'Ninja', name: 'Sam');",
          language: 'dart',
        ),
        LessonSection(
          title: 'Higher-Order Functions',
          text: 'Functions that take or return other functions:',
          code: "List<int> transform(List<int> nums, int Function(int) fn) {\n  return nums.map(fn).toList();\n}\n\nfinal scores = [60, 80, 45, 90, 70];\nfinal doubled = transform(scores, (x) => x * 2);\nfinal passing = scores.where((x) => x >= 60).toList();\n\nprint(doubled);   // [120, 160, 90, 180, 140]\nprint(passing);   // [60, 80, 90, 70]",
          language: 'dart',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'Cascade Notation ..',
          tipBody: 'myList..add(1)..add(2)..sort() chains multiple calls on the same object. Great for builders and setters.',
        ),
      ],
    ),

    'dart_2': LessonContent(
      lessonKey: 'dart_2', languageId: 'dart',
      languageEmoji: '🎯', title: 'Classes & OOP',
      subtitle: 'Object-oriented programming in Dart', xpReward: 70, coinReward: 15, estimatedMinutes: 16,
      voiceSummary: 'Dart is a fully object-oriented language. Every value is an object. Classes define blueprints for objects. Constructors create instances. Dart supports inheritance, mixins, and interfaces for powerful code reuse.',
      sections: [
        LessonSection(
          title: 'Defining a Class',
          text: 'Classes bundle data (fields) and behaviour (methods) together.',
          code: "class Player {\n  final String name;\n  int level;\n  int xp;\n\n  // Constructor\n  Player(this.name, {this.level = 1, this.xp = 0});\n\n  // Method\n  void gainXp(int amount) {\n    xp += amount;\n    if (xp >= level * 100) {\n      level++;\n      print('\$name levelled up to \$level!');\n    }\n  }\n\n  @override\n  String toString() => '\$name (Lv.\$level | \$xp XP)';\n}",
          language: 'dart',
        ),
        LessonSection(
          title: 'Inheritance',
          text: 'Extend a class to reuse and specialise it:',
          code: "class PremiumPlayer extends Player {\n  final String badge;\n\n  PremiumPlayer(super.name, this.badge);\n\n  @override\n  void gainXp(int amount) {\n    super.gainXp((amount * 1.5).round());  // 50% bonus\n  }\n}\n\nfinal p = PremiumPlayer('Alex', '⭐ Pro');\np.gainXp(100);   // actually gains 150 XP",
          language: 'dart',
        ),
        LessonSection(
          title: 'Getters & Setters',
          text: 'Control access to fields with computed properties:',
          code: "class Circle {\n  double radius;\n  Circle(this.radius);\n\n  double get area => 3.14159 * radius * radius;\n  double get diameter => radius * 2;\n\n  set diameter(double d) => radius = d / 2;\n}\n\nfinal c = Circle(5);\nprint(c.area);       // 78.54\nc.diameter = 20;     // sets radius to 10",
          language: 'dart',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'Mixins for Code Reuse',
          tipBody: 'mixin Flyable { void fly() => print("Flying!"); } — then class Hero with Flyable adds the fly method without inheritance. Great for cross-cutting concerns.',
        ),
      ],
    ),

    // ── Java ────────────────────────────────────────────────────────────────

    'java_0': LessonContent(
      lessonKey: 'java_0', languageId: 'java',
      languageEmoji: '☕', title: 'Variables & Primitive Types',
      subtitle: 'Java\'s strict type system', xpReward: 50, coinReward: 10, estimatedMinutes: 12,
      voiceSummary: 'Java is a strictly typed language. Every variable must have a type declared before use. Java has 8 primitive types for simple values and reference types for objects. Understanding the difference is fundamental to Java programming.',
      sections: [
        LessonSection(
          title: 'Primitive Types',
          text: 'Java has 8 primitive (non-object) types stored directly in memory:',
          typeGrid: [
            {'type': 'int', 'example': '42', 'colorHex': 0xFF00F5FF},
            {'type': 'long', 'example': '9L', 'colorHex': 0xFFBF00FF},
            {'type': 'double', 'example': '3.14', 'colorHex': 0xFF39FF14},
            {'type': 'float', 'example': '3.14f', 'colorHex': 0xFFFF6B00},
            {'type': 'boolean', 'example': 'true', 'colorHex': 0xFFFF006E},
            {'type': 'char', 'example': '\'A\'', 'colorHex': 0xFFFFE600},
          ],
        ),
        LessonSection(
          title: 'Declaring Variables',
          text: 'Java requires explicit type declarations. Use final to prevent reassignment.',
          code: "int score = 95;\ndouble xp = 4500.5;\nboolean isActive = true;\nchar grade = 'A';\n\n// final = can't reassign\nfinal String APP_NAME = \"CodeQuest\";\n\n// var (Java 10+) infers the type\nvar level = 12;       // inferred as int\nvar name = \"Alex\";    // inferred as String",
          language: 'java',
        ),
        LessonSection(
          title: 'Wrapper Classes',
          text: 'Every primitive has an object wrapper for use in collections:',
          code: "// Primitives\nint x = 5;\n\n// Wrappers (used in ArrayList, etc.)\nInteger y = 5;\nInteger z = Integer.parseInt(\"42\");\n\n// Autoboxing (auto-conversion)\nList<Integer> scores = new ArrayList<>();\nscores.add(95);   // int auto-boxed to Integer\nint first = scores.get(0);  // unboxed back",
          language: 'java',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'Integer vs int Performance',
          tipBody: 'Use int (primitive) for arithmetic — it is 5x faster than Integer. Only use Integer when you need a nullable value or a collection type.',
        ),
      ],
    ),

    'java_1': LessonContent(
      lessonKey: 'java_1', languageId: 'java',
      languageEmoji: '☕', title: 'Classes & Objects',
      subtitle: 'Java is built on objects', xpReward: 60, coinReward: 12, estimatedMinutes: 15,
      voiceSummary: 'In Java, everything lives inside a class. A class is a blueprint; an object is an instance created from that blueprint. Java uses constructors to initialize objects and access modifiers like public and private to control visibility.',
      sections: [
        LessonSection(
          title: 'Creating a Class',
          text: 'Every Java program is a class. Fields hold state, methods define behaviour.',
          code: "public class Player {\n    private String name;\n    private int level;\n    private int xp;\n\n    // Constructor\n    public Player(String name) {\n        this.name = name;\n        this.level = 1;\n        this.xp = 0;\n    }\n\n    // Getter\n    public String getName() { return name; }\n    public int getLevel() { return level; }\n\n    // Method\n    public void gainXp(int amount) {\n        xp += amount;\n        if (xp >= level * 100) level++;\n    }\n}",
          language: 'java',
        ),
        LessonSection(
          title: 'Creating Objects',
          text: 'Use new to create instances from a class:',
          code: "Player alex = new Player(\"Alex\");\nalex.gainXp(150);\nSystem.out.println(alex.getName() + \" Level: \" + alex.getLevel());\n\n// Multiple instances, independent state\nPlayer sam = new Player(\"Sam\");\nalex.gainXp(500);\n// sam is still level 1",
          language: 'java',
        ),
        LessonSection(
          title: 'Inheritance',
          text: 'Extend a class with extends:',
          code: "public class PremiumPlayer extends Player {\n    private String badge;\n\n    public PremiumPlayer(String name, String badge) {\n        super(name);  // call parent constructor\n        this.badge = badge;\n    }\n\n    @Override\n    public void gainXp(int amount) {\n        super.gainXp((int)(amount * 1.5)); // 50% bonus\n    }\n}",
          language: 'java',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'Encapsulation',
          tipBody: 'Always make fields private and expose them via public getters/setters. This lets you change internal implementation without breaking code that uses the class.',
        ),
      ],
    ),

    'java_2': LessonContent(
      lessonKey: 'java_2', languageId: 'java',
      languageEmoji: '☕', title: 'Arrays & ArrayList',
      subtitle: 'Fixed and dynamic collections', xpReward: 60, coinReward: 12, estimatedMinutes: 14,
      voiceSummary: 'Java has two main list structures. Arrays have a fixed size set at creation and are the fastest option. ArrayList is dynamic and can grow, but requires the Integer wrapper type instead of int. For most use cases, ArrayList is more convenient.',
      sections: [
        LessonSection(
          title: 'Arrays',
          text: 'Fixed-size. Fastest for number crunching.',
          code: "// Declare and initialise\nint[] scores = {95, 87, 72, 61, 88};\nString[] names = new String[5];  // size 5, all null\n\n// Access\nSystem.out.println(scores[0]);   // 95\nSystem.out.println(scores.length); // 5\n\n// Loop\nfor (int score : scores) {\n    System.out.println(score);\n}\n\n// 2D array\nint[][] grid = {{1,2},{3,4},{5,6}};",
          language: 'java',
        ),
        LessonSection(
          title: 'ArrayList',
          text: 'Dynamic size — grows and shrinks automatically:',
          code: "import java.util.ArrayList;\n\nArrayList<String> players = new ArrayList<>();\nplayers.add(\"Alex\");\nplayers.add(\"Sam\");\nplayers.add(\"Jo\");\n\nSystem.out.println(players.size());     // 3\nSystem.out.println(players.get(0));     // Alex\nplayers.remove(\"Sam\");                  // remove by value\nplayers.set(0, \"Zara\");                // replace",
          language: 'java',
        ),
        LessonSection(
          title: 'Sorting & Searching',
          text: 'Use the built-in Arrays and Collections utilities:',
          code: "import java.util.Arrays;\nimport java.util.Collections;\n\nint[] arr = {5, 2, 8, 1, 9};\nArrays.sort(arr);\n// arr is now {1, 2, 5, 8, 9}\n\nArrayList<Integer> list = new ArrayList<>();\nCollections.sort(list);\nCollections.reverse(list);\nint max = Collections.max(list);",
          language: 'java',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'Enhanced for vs Iterator',
          tipBody: 'Use enhanced for (for-each) for readability. Use Iterator when you need to remove elements during iteration — otherwise you\'ll get ConcurrentModificationException.',
        ),
      ],
    ),

    // ── C++ ─────────────────────────────────────────────────────────────────

    'cpp_0': LessonContent(
      lessonKey: 'cpp_0', languageId: 'cpp',
      languageEmoji: '⚙️', title: 'Variables & Pointers',
      subtitle: 'Direct memory access — C++\'s superpower', xpReward: 80, coinReward: 20, estimatedMinutes: 18,
      voiceSummary: 'C++ gives you direct control over memory through pointers. A pointer stores the memory address of another variable. The ampersand operator gets the address of a variable. The asterisk operator dereferences a pointer to get the value at that address.',
      sections: [
        LessonSection(
          title: 'Basic Variables',
          text: 'C++ requires explicit types. Unlike Python, memory is managed manually.',
          code: "#include <iostream>\nusing namespace std;\n\nint main() {\n    int score = 95;\n    double xp = 4500.5;\n    bool isActive = true;\n    char grade = 'A';\n    string name = \"CodeQuest\";  // std::string\n\n    cout << score << endl;   // 95\n    return 0;\n}",
          language: 'cpp',
        ),
        LessonSection(
          title: 'Pointers',
          text: 'A pointer stores the memory address of a variable:',
          code: "int score = 95;\nint* ptr = &score;   // ptr holds address of score\n\ncout << score;   // 95 (value)\ncout << &score;  // 0x7ff... (address)\ncout << ptr;     // 0x7ff... (same address)\ncout << *ptr;    // 95 (dereference → value)\n\n// Modify through pointer\n*ptr = 100;\ncout << score;   // 100 (changed!)",
          language: 'cpp',
        ),
        LessonSection(
          title: 'References',
          text: 'References are aliases — simpler and safer than pointers:',
          code: "int score = 95;\nint& ref = score;   // ref IS score\n\nref = 100;\ncout << score;   // 100 (same memory)\n\n// Reference parameters (pass by reference)\nvoid addBonus(int& s, int bonus) {\n    s += bonus;   // modifies the original\n}\n\naddBonus(score, 50);\ncout << score;   // 150",
          language: 'cpp',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'Pointer vs Reference',
          tipBody: 'Use references when you don\'t need to change what you\'re pointing to. Use pointers when you need nullptr, pointer arithmetic, or to reassign what you\'re pointing at.',
        ),
      ],
    ),

    'cpp_1': LessonContent(
      lessonKey: 'cpp_1', languageId: 'cpp',
      languageEmoji: '⚙️', title: 'Classes & Memory',
      subtitle: 'OOP with manual memory management', xpReward: 80, coinReward: 20, estimatedMinutes: 20,
      voiceSummary: 'C++ classes are similar to Java but you control memory allocation. Objects can live on the stack, created by value, or on the heap, created with new. Heap objects must be deleted manually, or you get a memory leak. Modern C++ uses smart pointers to handle this automatically.',
      sections: [
        LessonSection(
          title: 'Defining a Class',
          text: 'C++ classes have a header (declaration) and implementation.',
          code: "class Player {\nprivate:\n    string name;\n    int level;\n    int xp;\n\npublic:\n    // Constructor\n    Player(string n) : name(n), level(1), xp(0) {}\n\n    void gainXp(int amount) {\n        xp += amount;\n        if (xp >= level * 100) level++;\n    }\n\n    string getName() const { return name; }\n    int getLevel() const { return level; }\n};",
          language: 'cpp',
        ),
        LessonSection(
          title: 'Stack vs Heap',
          text: 'Stack objects are automatic. Heap objects need manual cleanup:',
          code: "// Stack (automatic cleanup)\nPlayer p1(\"Alex\");    // destroyed when out of scope\np1.gainXp(100);\n\n// Heap (manual — use new/delete)\nPlayer* p2 = new Player(\"Sam\");\np2->gainXp(200);      // -> for pointer access\ndelete p2;            // MUST delete!\n\n// Modern C++: smart pointers (auto-delete)\n#include <memory>\nauto p3 = make_unique<Player>(\"Jo\");\np3->gainXp(300);      // auto-deleted when done",
          language: 'cpp',
        ),
        LessonSection(
          title: 'Destructor',
          text: 'Called automatically when an object is destroyed:',
          code: "class Connection {\npublic:\n    Connection() { cout << \"Connected!\\n\"; }\n    ~Connection() { cout << \"Disconnected!\\n\"; }\n    // ~ prefix = destructor\n};\n\n{\n    Connection c;\n    // ... use c\n}  // destructor called here automatically",
          language: 'cpp',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'Rule of Three',
          tipBody: 'If you define a destructor, you should also define a copy constructor and copy assignment operator. This is called the Rule of Three (or Five in modern C++).',
        ),
      ],
    ),

    // ── C ───────────────────────────────────────────────────────────────────

    'c_0': LessonContent(
      lessonKey: 'c_0', languageId: 'c',
      languageEmoji: '🔧', title: 'Variables & Data Types',
      subtitle: 'The foundation of all programming', xpReward: 60, coinReward: 12, estimatedMinutes: 14,
      voiceSummary: 'C is a low-level language where you have direct control over memory. Every variable has a type that determines how much memory it uses. Understanding data types is critical in C because using the wrong type can cause silent bugs or crashes.',
      sections: [
        LessonSection(
          title: 'Basic Types',
          text: 'C types map directly to hardware memory sizes:',
          typeGrid: [
            {'type': 'int', 'example': '42', 'colorHex': 0xFF00F5FF},
            {'type': 'float', 'example': '3.14f', 'colorHex': 0xFFBF00FF},
            {'type': 'double', 'example': '3.14', 'colorHex': 0xFF39FF14},
            {'type': 'char', 'example': '\'A\'', 'colorHex': 0xFFFF6B00},
            {'type': 'long', 'example': '100L', 'colorHex': 0xFFFF006E},
            {'type': 'short', 'example': '5', 'colorHex': 0xFFFFE600},
          ],
        ),
        LessonSection(
          title: 'Declaring Variables',
          text: 'All variables must be declared before use. C89 requires declarations at the top of a block.',
          code: '#include <stdio.h>\n\nint main() {\n    int score = 95;\n    float xp = 4500.5f;\n    double pi = 3.14159265;\n    char grade = \'A\';\n    \n    printf("Score: %d\\n", score);\n    printf("XP: %.1f\\n", xp);\n    printf("Grade: %c\\n", grade);\n    \n    return 0;\n}',
          language: 'c',
        ),
        LessonSection(
          title: 'Pointers',
          text: 'C\'s most powerful (and dangerous) feature:',
          code: 'int score = 95;\nint *ptr = &score;  // & gets address\n\nprintf("%d\\n", score);   // 95\nprintf("%p\\n", ptr);     // memory address\nprintf("%d\\n", *ptr);    // 95 (dereference)\n\n*ptr = 100;\nprintf("%d\\n", score);   // 100',
          language: 'c',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'sizeof Operator',
          tipBody: 'sizeof(int) returns 4 on most systems (4 bytes = 32 bits). Always use sizeof instead of hardcoding sizes — it keeps your code portable across different platforms.',
        ),
      ],
    ),

    'c_1': LessonContent(
      lessonKey: 'c_1', languageId: 'c',
      languageEmoji: '🔧', title: 'Functions & Arrays',
      subtitle: 'Organizing code and storing collections', xpReward: 60, coinReward: 12, estimatedMinutes: 15,
      voiceSummary: 'In C, functions must be declared before they are used. Arrays are stored as contiguous blocks of memory. When you pass an array to a function, you actually pass a pointer to its first element, so functions can modify the original array.',
      sections: [
        LessonSection(
          title: 'Functions',
          text: 'Declare the return type before the function name. Declare before use or use a prototype.',
          code: '#include <stdio.h>\n\n// Function prototype\nint add(int a, int b);\nvoid printScore(int score);\n\nint main() {\n    int result = add(3, 4);\n    printScore(result);\n    return 0;\n}\n\nint add(int a, int b) {\n    return a + b;\n}\n\nvoid printScore(int score) {\n    printf("Score: %d\\n", score);\n}',
          language: 'c',
        ),
        LessonSection(
          title: 'Arrays',
          text: 'Fixed-size sequential memory. Index starts at 0.',
          code: 'int scores[5] = {95, 87, 72, 61, 88};\nint size = 5;\n\n// Access\nprintf("%d\\n", scores[0]);  // 95\n\n// Loop\nfor (int i = 0; i < size; i++) {\n    printf("Score %d: %d\\n", i+1, scores[i]);\n}\n\n// Sum\nint total = 0;\nfor (int i = 0; i < size; i++) total += scores[i];\nprintf("Average: %.1f\\n", (float)total/size);',
          language: 'c',
        ),
        LessonSection(
          title: 'Passing Arrays to Functions',
          text: 'Arrays decay to pointers when passed — changes affect the original:',
          code: 'void doubleAll(int arr[], int n) {\n    for (int i = 0; i < n; i++) {\n        arr[i] *= 2;  // modifies original!\n    }\n}\n\nint scores[] = {10, 20, 30};\ndoubleAll(scores, 3);\n// scores is now {20, 40, 60}',
          language: 'c',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'Array Bounds',
          tipBody: 'C does NOT check array bounds. Accessing scores[10] on a size-5 array is undefined behaviour — it can corrupt memory or crash silently. Always track your array sizes manually.',
        ),
      ],
    ),

    'c_2': LessonContent(
      lessonKey: 'c_2', languageId: 'c',
      languageEmoji: '🔧', title: 'Structs & Memory Management',
      subtitle: 'Custom data types and dynamic memory', xpReward: 80, coinReward: 20, estimatedMinutes: 18,
      voiceSummary: 'Structs let you group related variables under one name, like a class without methods. Dynamic memory allocation with malloc and free lets you allocate memory at runtime. Always free memory you allocate, or you will have a memory leak.',
      sections: [
        LessonSection(
          title: 'Structs',
          text: 'Group related variables into a custom type:',
          code: 'typedef struct {\n    char name[50];\n    int level;\n    float xp;\n    int lives;\n} Player;\n\nPlayer p1;\np1.level = 12;\np1.xp = 4500.5f;\np1.lives = 3;\n\nPlayer p2 = {"Alex", 1, 0.0f, 5};\nprintf("%s is level %d\\n", p2.name, p2.level);',
          language: 'c',
        ),
        LessonSection(
          title: 'Dynamic Memory',
          text: 'Allocate memory at runtime with malloc:',
          code: '#include <stdlib.h>\n\n// Allocate memory for 5 ints\nint *scores = malloc(5 * sizeof(int));\nif (scores == NULL) {\n    // malloc failed!\n    return 1;\n}\n\nscores[0] = 95;\nscores[1] = 87;\n\n// MUST free when done\nfree(scores);\nscores = NULL;  // avoid dangling pointer',
          language: 'c',
        ),
        LessonSection(
          title: 'Struct Pointers',
          text: 'Access struct members through a pointer with the -> operator:',
          code: 'Player *ptr = malloc(sizeof(Player));\nptr->level = 5;       // same as (*ptr).level\nptr->xp = 1000.0f;\n\nprintf("Level: %d\\n", ptr->level);\n\nfree(ptr);',
          language: 'c',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'Valgrind for Memory Leaks',
          tipBody: 'Run valgrind ./your_program to detect memory leaks, double-frees, and invalid reads. Every serious C developer uses it. On Windows, use Dr. Memory instead.',
        ),
      ],
    ),

    // ── Additional Python Lessons ──────────────────────────────────────────

    'python_5': LessonContent(
      lessonKey: 'python_5', languageId: 'python',
      languageEmoji: '🐍', title: 'File I/O & Exception Handling',
      subtitle: 'Read, write files and handle errors gracefully', xpReward: 70, coinReward: 15, estimatedMinutes: 14,
      voiceSummary: 'In Python, the with statement ensures files are properly closed after operations. The try and except blocks catch runtime errors without crashing your program.',
      sections: [
        LessonSection(
          title: 'Reading & Writing Files',
          text: 'Use the with open() context manager for safe file handling:',
          code: '# Writing to a file\nwith open("player_data.txt", "w") as f:\n    f.write("Player: Alex\\nScore: 2500\\n")\n\n# Reading from a file\nwith open("player_data.txt", "r") as f:\n    for line in f:\n        print(line.strip())',
          language: 'python',
        ),
        LessonSection(
          title: 'Handling Exceptions',
          text: 'Catch specific exceptions using try and except:',
          code: 'try:\n    number = int("invalid_123")\nexcept ValueError as e:\n    print(f"Conversion error: {e}")\nfinally:\n    print("Execution complete")',
          language: 'python',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'Custom Exceptions',
          tipBody: 'Create your own exceptions by subclassing Exception: class GameError(Exception): pass. This makes debugging much cleaner.',
        ),
      ],
    ),

    'python_6': LessonContent(
      lessonKey: 'python_6', languageId: 'python',
      languageEmoji: '🐍', title: 'Object-Oriented Python',
      subtitle: 'Build classes, instances, and inheritance hierarchies', xpReward: 80, coinReward: 18, estimatedMinutes: 16,
      voiceSummary: 'Object-oriented programming bundles data and behaviors into classes. Use the dunder init method as constructor and self to reference instance fields.',
      sections: [
        LessonSection(
          title: 'Classes and __init__',
          text: 'Define blueprints for objects with the class keyword:',
          code: 'class Hero:\n    def __init__(self, name, hp=100):\n        self.name = name\n        self.hp = hp\n\n    def take_damage(self, amount):\n        self.hp = max(0, self.hp - amount)\n        print(f"{self.name} has {self.hp} HP left")\n\nhero = Hero("Alex", 120)\nhero.take_damage(25)',
          language: 'python',
        ),
        LessonSection(
          title: 'Inheritance & super()',
          text: 'Extend classes and override methods seamlessly:',
          code: 'class Mage(Hero):\n    def __init__(self, name, mana=50):\n        super().__init__(name, hp=80)\n        self.mana = mana\n\nmage = Mage("Zara", 100)\nprint(f"{mage.name}: HP={mage.hp}, Mana={mage.mana}")',
          language: 'python',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: '__str__ and __repr__',
          tipBody: 'Implement __str__ on your classes to return a human-readable representation when someone calls print(obj).',
        ),
      ],
    ),

    // ── Additional JavaScript Lessons ──────────────────────────────────────

    'javascript_4': LessonContent(
      lessonKey: 'javascript_4', languageId: 'javascript',
      languageEmoji: '⚡', title: 'DOM & Event Handling',
      subtitle: 'Interact with the web page dynamically', xpReward: 65, coinReward: 14, estimatedMinutes: 14,
      voiceSummary: 'The Document Object Model connects web pages to scripts. Use querySelector to grab elements and addEventListener to respond to user clicks, typing, and mouse movements.',
      sections: [
        LessonSection(
          title: 'Selecting & Modifying Elements',
          text: 'Target elements with CSS selectors and change their styles and text:',
          code: "const title = document.querySelector('#header-title');\ntitle.textContent = 'Welcome, Cyber Hero!';\ntitle.style.color = '#00F5FF';\ntitle.classList.add('neon-glow');",
          language: 'javascript',
        ),
        LessonSection(
          title: 'Event Listeners',
          text: 'Listen for clicks, inputs, and key presses without inline HTML handlers:',
          code: "const btn = document.querySelector('#attack-btn');\nbtn.addEventListener('click', (event) => {\n  console.log('Button clicked!', event.target);\n  alert('Attack initiated!');\n});",
          language: 'javascript',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'Event Delegation',
          tipBody: 'Attach a single listener to a parent element instead of hundreds of child buttons. It saves memory and handles dynamically added elements automatically.',
        ),
      ],
    ),

    'javascript_5': LessonContent(
      lessonKey: 'javascript_5', languageId: 'javascript',
      languageEmoji: '⚡', title: 'ES6+ Modules & Destructuring',
      subtitle: 'Modern code organization and syntax shortcuts', xpReward: 70, coinReward: 15, estimatedMinutes: 15,
      voiceSummary: 'Modern JavaScript uses ES Modules with import and export keywords. Object and array destructuring lets you unpack properties into distinct variables cleanly.',
      sections: [
        LessonSection(
          title: 'Destructuring & Spread',
          text: 'Unpack values effortlessly and merge objects immutably:',
          code: "const player = { username: 'Alex', score: 950, rank: 'Diamond' };\nconst { username, score } = player;\n\n// Spread to clone & update\nconst updated = { ...player, score: score + 50, level: 12 };\nconsole.log(updated.score); // 1000",
          language: 'javascript',
        ),
        LessonSection(
          title: 'ES Modules',
          text: 'Organize files into clean, reusable modules:',
          code: "// utils.js\nexport const add = (a, b) => a + b;\nexport default class Logger {}\n\n// app.js\nimport Logger, { add } from './utils.js';",
          language: 'javascript',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'Optional Chaining ?.',
          tipBody: 'user?.profile?.avatar safely accesses deeply nested fields without throwing a TypeError if an intermediate key is null or undefined.',
        ),
      ],
    ),

    // ── Additional Dart Lessons ────────────────────────────────────────────

    'dart_3': LessonContent(
      lessonKey: 'dart_3', languageId: 'dart',
      languageEmoji: '🎯', title: 'Collections & Generics',
      subtitle: 'Type-safe Lists, Maps, and Sets', xpReward: 65, coinReward: 14, estimatedMinutes: 14,
      voiceSummary: 'Dart provides powerful generic collection types: List for ordered sequences, Map for key-value dictionaries, and Set for unique items. Generics ensure complete type safety at compile time.',
      sections: [
        LessonSection(
          title: 'Lists and Collection Methods',
          text: 'Transform lists using functional methods like map, where, and fold:',
          code: "final numbers = [1, 2, 3, 4, 5];\nfinal evens = numbers.where((n) => n.isEven).toList();\nfinal doubled = numbers.map((n) => n * 2).toList();\nfinal total = numbers.fold(0, (sum, n) => sum + n);\n\nprint(doubled); // [2, 4, 6, 8, 10]\nprint('Total: \$total'); // Total: 15",
          language: 'dart',
        ),
        LessonSection(
          title: 'Maps and Sets',
          text: 'Hash tables and unique sets in Dart:',
          code: "final scores = <String, int>{'Alex': 95, 'Sam': 88};\nscores['Zara'] = 99;\n\nfinal uniqueTags = <String>{'flutter', 'dart', 'flutter'};\nprint(uniqueTags.length); // 2 (no duplicates)",
          language: 'dart',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'Collection If and For',
          tipBody: 'Dart allows inline collection-if and collection-for: [1, 2, if (isPro) 3, for (var x in list) x * 2]. Incredibly useful when building Flutter widget trees!',
        ),
      ],
    ),

    'dart_4': LessonContent(
      lessonKey: 'dart_4', languageId: 'dart',
      languageEmoji: '🎯', title: 'Async Dart: Futures & Streams',
      subtitle: 'Asynchronous programming and reactive streams', xpReward: 75, coinReward: 18, estimatedMinutes: 16,
      voiceSummary: 'A Future represents a computation that finishes in the future. A Stream emits multiple asynchronous data events over time. Use async, await, and async* to write clean asynchronous code.',
      sections: [
        LessonSection(
          title: 'Futures & async/await',
          text: 'Pause execution cleanly until an asynchronous value arrives:',
          code: "Future<String> fetchUser() async {\n  await Future.delayed(const Duration(seconds: 1));\n  return 'Cyber Ninja';\n}\n\nvoid main() async {\n  print('Loading...');\n  final user = await fetchUser();\n  print('Hello \$user!');\n}",
          language: 'dart',
        ),
        LessonSection(
          title: 'Streams & async*',
          text: 'Emit multiple values over time with reactive streams:',
          code: "Stream<int> countdown(int from) async* {\n  for (int i = from; i >= 0; i--) {\n    await Future.delayed(const Duration(milliseconds: 500));\n    yield i;\n  }\n}\n\nvoid main() async {\n  await for (final tick in countdown(3)) {\n    print('Tick: \$tick');\n  }\n}",
          language: 'dart',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'StreamController',
          tipBody: 'Use StreamController<T>.broadcast() when you need multiple listeners (such as state updates or event buses) in your Flutter applications.',
        ),
      ],
    ),

    // ── Additional Java Lessons ────────────────────────────────────────────

    'java_3': LessonContent(
      lessonKey: 'java_3', languageId: 'java',
      languageEmoji: '☕', title: 'Inheritance & Interfaces',
      subtitle: 'Polymorphism and contract-driven architecture', xpReward: 70, coinReward: 15, estimatedMinutes: 15,
      voiceSummary: 'Java uses extends for single class inheritance and implements for multiple interface contracts. Polymorphism lets you treat specialized objects through their shared base type.',
      sections: [
        LessonSection(
          title: 'Abstract Classes vs Interfaces',
          text: 'Define shared behavior and contracts:',
          code: "interface Drawable {\n    void draw();\n}\n\nabstract class Shape implements Drawable {\n    abstract double getArea();\n}\n\nclass Circle extends Shape {\n    private double r;\n    Circle(double r) { this.r = r; }\n    public double getArea() { return Math.PI * r * r; }\n    public void draw() { System.out.println(\"Drawing Circle\"); }\n}",
          language: 'java',
        ),
        LessonSection(
          title: 'Polymorphism in Action',
          text: 'Call overridden methods through interface references:',
          code: "Drawable d = new Circle(5.0);\nd.draw(); // Invokes Circle's implementation\n\nShape s = new Circle(10.0);\nSystem.out.println(\"Area: \" + s.getArea());",
          language: 'java',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'Default Methods',
          tipBody: 'Since Java 8, interfaces can contain default implementations: default void log() { System.out.println("Log"); }. This allows backward-compatible interface enhancements.',
        ),
      ],
    ),

    'java_4': LessonContent(
      lessonKey: 'java_4', languageId: 'java',
      languageEmoji: '☕', title: 'Java Collections Framework',
      subtitle: 'Master List, Set, Map, and Iterators', xpReward: 70, coinReward: 15, estimatedMinutes: 15,
      voiceSummary: 'The Java Collections Framework standardizes data structures. ArrayList provides fast indexed access, HashSet eliminates duplicates, and HashMap stores fast key-value associations.',
      sections: [
        LessonSection(
          title: 'HashMap & HashSet',
          text: 'O(1) average lookup and unique sets:',
          code: "Map<String, Integer> scores = new HashMap<>();\nscores.put(\"Alex\", 950);\nscores.put(\"Sam\", 870);\n\nif (scores.containsKey(\"Alex\")) {\n    int val = scores.get(\"Alex\");\n    System.out.println(\"Alex score: \" + val);\n}\n\nSet<String> unique = new HashSet<>(Arrays.asList(\"A\", \"B\", \"A\"));\nSystem.out.println(unique.size()); // 2",
          language: 'java',
        ),
        LessonSection(
          title: 'Sorting Collections',
          text: 'Sort with Collections.sort and lambda Comparators:',
          code: "List<String> names = new ArrayList<>(List.of(\"Charlie\", \"Alice\", \"Bob\"));\nCollections.sort(names);\n// Or custom comparator:\nnames.sort((a, b) -> Integer.compare(a.length(), b.length()));",
          language: 'java',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'getOrDefault',
          tipBody: 'Use map.getOrDefault(key, 0) when tallying frequency counts. It eliminates manual null checks completely.',
        ),
      ],
    ),

    // ── Additional C++ Lessons ─────────────────────────────────────────────

    'cpp_2': LessonContent(
      lessonKey: 'cpp_2', languageId: 'cpp',
      languageEmoji: '⚙️', title: 'STL Containers: Vector & Map',
      subtitle: 'High performance Standard Template Library collections', xpReward: 75, coinReward: 18, estimatedMinutes: 16,
      voiceSummary: 'The C++ Standard Template Library provides heavily optimized container templates like std::vector for dynamic arrays and std::unordered_map for lightning-fast hash lookups.',
      sections: [
        LessonSection(
          title: 'std::vector',
          text: 'Contiguous, cache-friendly dynamic array in C++:',
          code: "#include <iostream>\n#include <vector>\n#include <algorithm>\n\nint main() {\n    std::vector<int> nums = {5, 2, 9, 1, 7};\n    nums.push_back(10);\n    \n    std::sort(nums.begin(), nums.end());\n    \n    for (int n : nums) {\n        std::cout << n << \" \";\n    }\n    return 0;\n}",
          language: 'cpp',
        ),
        LessonSection(
          title: 'std::map & std::unordered_map',
          text: 'Key-value lookups with balanced trees vs hash tables:',
          code: "#include <unordered_map>\n#include <string>\n\nstd::unordered_map<std::string, int> bank;\nbank[\"Alex\"] = 1000;\nbank[\"Sam\"] = 850;\n\nif (bank.find(\"Alex\") != bank.end()) {\n    std::cout << \"Found: \" << bank[\"Alex\"] << std::endl;\n}",
          language: 'cpp',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'vector::reserve',
          tipBody: 'Always call vec.reserve(n) if you know the approximate size in advance. It avoids costly heap reallocations and buffer copies.',
        ),
      ],
    ),

    'cpp_3': LessonContent(
      lessonKey: 'cpp_3', languageId: 'cpp',
      languageEmoji: '⚙️', title: 'Templates & Smart Pointers',
      subtitle: 'Compile-time generic programming and automatic memory safety', xpReward: 85, coinReward: 20, estimatedMinutes: 18,
      voiceSummary: 'C++ templates enable writing type-independent algorithms. Modern C++ uses std::unique_ptr and std::shared_ptr to manage heap resources automatically, eliminating manual delete.',
      sections: [
        LessonSection(
          title: 'Function & Class Templates',
          text: 'Generic code instantiated at compile time with zero overhead:',
          code: "template <typename T>\nT getMax(T a, T b) {\n    return (a > b) ? a : b;\n}\n\nint main() {\n    std::cout << getMax<int>(3, 7) << std::endl;       // 7\n    std::cout << getMax<double>(3.14, 2.71) << std::endl; // 3.14\n    return 0;\n}",
          language: 'cpp',
        ),
        LessonSection(
          title: 'Smart Pointers in C++11',
          text: 'Automatic memory management via RAII:',
          code: "#include <memory>\n\nstruct Node { int val; Node(int v): val(v) {} };\n\nvoid run() {\n    // Automatically deleted when out of scope!\n    auto ptr = std::make_unique<Node>(42);\n    std::cout << ptr->val << std::endl;\n} // Deleted here safely",
          language: 'cpp',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'std::make_unique',
          tipBody: 'Always prefer std::make_unique<T>() over new T() — it prevents subtle exception-safety memory leaks and avoids redundant type declarations.',
        ),
      ],
    ),

    // ── Additional C Lessons ───────────────────────────────────────────────

    'c_3': LessonContent(
      lessonKey: 'c_3', languageId: 'c',
      languageEmoji: '🔧', title: 'Pointer Arithmetic & Arrays',
      subtitle: 'Navigating raw memory offsets directly', xpReward: 75, coinReward: 16, estimatedMinutes: 16,
      voiceSummary: 'In C, array indexing is simply pointer arithmetic in disguise. Adding 1 to a pointer advances it by the size of the underlying data type in bytes.',
      sections: [
        LessonSection(
          title: 'Pointer Math & Offsets',
          text: 'Incrementing a pointer steps forward by sizeof(type):',
          code: "#include <stdio.h>\n\nint main() {\n    int arr[4] = {10, 20, 30, 40};\n    int *ptr = arr; // points to arr[0]\n    \n    printf(\"%d\\n\", *ptr);       // 10\n    printf(\"%d\\n\", *(ptr + 1)); // 20 (same as arr[1])\n    \n    ptr++;\n    printf(\"%d\\n\", *ptr);       // 20\n    return 0;\n}",
          language: 'c',
        ),
        LessonSection(
          title: 'Passing Pointers to Functions',
          text: 'Modify caller variables and swap values in memory:',
          code: "void swap(int *a, int *b) {\n    int temp = *a;\n    *a = *b;\n    *b = temp;\n}\n\nint x = 5, y = 10;\nswap(&x, &y);\n// x is now 10, y is 5",
          language: 'c',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'Null Pointers',
          tipBody: 'Always check if (ptr != NULL) before dereferencing. Dereferencing a NULL pointer triggers an instant Segmentation Fault.',
        ),
      ],
    ),

    'c_4': LessonContent(
      lessonKey: 'c_4', languageId: 'c',
      languageEmoji: '🔧', title: 'C Strings & string.h',
      subtitle: 'Null-terminated character buffers and string functions', xpReward: 70, coinReward: 15, estimatedMinutes: 15,
      voiceSummary: 'In C, strings are null-terminated character arrays. The string.h library provides functions like strlen, strcpy, strcat, and strcmp to manipulate text buffers safely.',
      sections: [
        LessonSection(
          title: 'Character Arrays & Null Terminator',
          text: 'Every C string must end with a zero byte (\\0):',
          code: "#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char greeting[20] = \"Hello\";\n    strcat(greeting, \", Hero!\");\n    \n    printf(\"%s\\n\", greeting); // Hello, Hero!\n    printf(\"Length: %zu\\n\", strlen(greeting)); // 12\n    return 0;\n}",
          language: 'c',
        ),
        LessonSection(
          title: 'Safe String Operations',
          text: 'Prevent buffer overflow attacks by checking bounds:',
          code: "char dest[10];\n// snprintf prevents buffer overflow by capping maximum length:\nsnprintf(dest, sizeof(dest), \"%s\", \"CyberWarrior2026\");\nprintf(\"Safe: %s\\n\", dest); // Truncates cleanly to 9 chars + '\\0'",
          language: 'c',
        ),
        LessonSection(
          title: 'Pro Tip', text: '',
          tipTitle: 'strcmp return value',
          tipBody: 'strcmp(s1, s2) returns 0 when the strings match. So write if (strcmp(a, b) == 0) for equality, not if (strcmp(a, b)).',
        ),
      ],
    ),
  };
}
