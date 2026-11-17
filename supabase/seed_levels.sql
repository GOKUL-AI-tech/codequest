-- =============================================================================
-- CodeQuest – Level-Based Seed Data
-- 6 languages × 3 levels × 3 chapters × 4 lessons each
-- unlock_requirement: 0 = Level 1 (Beginner), 1 = Level 2 (Intermediate), 2 = Level 3 (Expert)
-- Run this in Supabase SQL Editor AFTER the schema migrations.
-- =============================================================================

-- Clear existing data (safe to re-run)
DELETE FROM quiz_questions;
DELETE FROM lessons;
DELETE FROM chapters;

-- =============================================================================
--  PYTHON
-- =============================================================================

-- ── Python Level 1 Chapters ──────────────────────────────────────────────────
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES
  ('py-l1-c1', 'python', 'Python Basics',          'Variables, data types and your first program',   1, 0, 4, '🐍', true),
  ('py-l1-c2', 'python', 'Control Flow',            'if/else, loops and decision making',             2, 0, 4, '🔀', true),
  ('py-l1-c3', 'python', 'Functions & Scope',       'Defining functions, parameters and return values', 3, 0, 4, '⚙️', true);

-- ── Python Level 2 Chapters ──────────────────────────────────────────────────
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES
  ('py-l2-c1', 'python', 'Lists & Dictionaries',   'Collections, indexing and common methods',       4, 1, 4, '📦', true),
  ('py-l2-c2', 'python', 'Object-Oriented Python', 'Classes, objects, inheritance and encapsulation', 5, 1, 4, '🏗️', true),
  ('py-l2-c3', 'python', 'File I/O & Exceptions',  'Reading/writing files and error handling',       6, 1, 4, '💾', true);

-- ── Python Level 3 Chapters ──────────────────────────────────────────────────
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES
  ('py-l3-c1', 'python', 'Algorithms & Complexity', 'Sorting, searching and Big O analysis',         7, 2, 4, '📊', true),
  ('py-l3-c2', 'python', 'Decorators & Generators', 'Advanced Python patterns and lazy evaluation',   8, 2, 4, '✨', true),
  ('py-l3-c3', 'python', 'Concurrency & Async',    'Threading, multiprocessing and asyncio',         9, 2, 4, '⚡', true);

-- ── Python Lessons – Level 1 Chapter 1 ───────────────────────────────────────
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES
  ('py-l1-c1-l1', 'py-l1-c1', 'python', 'Hello, World!',        'Write your very first Python program',            'theory',  'beginner', 1, 50, 10, '# Hello, World!\n\nEvery programmer''s journey starts here.\n\n```python\nprint("Hello, World!")\n```\n\nThe `print()` function outputs text to the console. Strings are enclosed in quotes.', '["python","basics","print"]', 10, true),
  ('py-l1-c1-l2', 'py-l1-c1', 'python', 'Variables',            'Store and name your data',                        'theory',  'beginner', 2, 50, 10, '# Variables\n\nVariables are containers for storing data.\n\n```python\nname = "Alex"\nage = 20\nheight = 1.75\nlearning = True\n```\n\nPython is dynamically typed — no need to declare types.', '["python","variables","types"]', 12, true),
  ('py-l1-c1-l3', 'py-l1-c1', 'python', 'Data Types Quiz',      'Test your knowledge of Python data types',        'quiz',    'beginner', 3, 30, 8,  NULL, '["python","quiz","types"]', 8, true),
  ('py-l1-c1-l4', 'py-l1-c1', 'python', 'Input & Output',       'Read user input and display results',             'coding',  'beginner', 4, 100, 20, '# Input & Output\n\nUse `input()` to read data and `print()` to display it.\n\n```python\nname = input("Enter your name: ")\nprint(f"Hello, {name}!")\n```', '["python","input","output"]', 15, true);

-- ── Python Lessons – Level 1 Chapter 2 ───────────────────────────────────────
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES
  ('py-l1-c2-l1', 'py-l1-c2', 'python', 'if / else Statements',  'Make decisions in your code',                  'theory',  'beginner', 1, 50, 10, '# if / else\n\n```python\nscore = 85\nif score >= 90:\n    print("A grade")\nelif score >= 70:\n    print("B grade")\nelse:\n    print("Keep practicing")\n```', '["python","conditionals","if"]', 12, true),
  ('py-l1-c2-l2', 'py-l1-c2', 'python', 'for Loops',             'Repeat actions with for loops',                'theory',  'beginner', 2, 50, 10, '# for Loops\n\n```python\nfor i in range(5):\n    print(i)\n\nfruits = ["apple","banana","cherry"]\nfor fruit in fruits:\n    print(fruit)\n```', '["python","loops","for"]', 12, true),
  ('py-l1-c2-l3', 'py-l1-c2', 'python', 'while Loops',           'Loop until a condition is false',              'theory',  'beginner', 3, 50, 10, '# while Loops\n\n```python\ncount = 0\nwhile count < 5:\n    print(count)\n    count += 1\n```\n\nAlways ensure the condition eventually becomes False to avoid infinite loops.', '["python","loops","while"]', 10, true),
  ('py-l1-c2-l4', 'py-l1-c2', 'python', 'FizzBuzz Challenge',    'Classic coding challenge using loops',         'coding',  'beginner', 4, 100, 20, NULL, '["python","loops","challenge"]', 15, true);

-- ── Python Lessons – Level 1 Chapter 3 ───────────────────────────────────────
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES
  ('py-l1-c3-l1', 'py-l1-c3', 'python', 'Defining Functions',    'Create reusable blocks of code',              'theory',  'beginner', 1, 50, 10, '# Defining Functions\n\n```python\ndef greet(name):\n    return f"Hello, {name}!"\n\nresult = greet("Gokul")\nprint(result)\n```', '["python","functions","def"]', 12, true),
  ('py-l1-c3-l2', 'py-l1-c3', 'python', 'Parameters & Return',   'Pass data in and get results back',           'theory',  'beginner', 2, 50, 10, '# Parameters & Return Values\n\n```python\ndef add(a, b):\n    return a + b\n\ndef greet(name="World"):  # default param\n    print(f"Hello, {name}!")\n```', '["python","parameters","return"]', 12, true),
  ('py-l1-c3-l3', 'py-l1-c3', 'python', 'Scope & Namespaces',    'Understand local vs global variables',        'theory',  'beginner', 3, 50, 10, '# Scope\n\n```python\nx = 10  # global\n\ndef change():\n    global x\n    x = 20\n\nchange()\nprint(x)  # 20\n```', '["python","scope","global"]', 10, true),
  ('py-l1-c3-l4', 'py-l1-c3', 'python', 'Calculator Function',   'Build a basic calculator using functions',    'coding',  'beginner', 4, 100, 20, NULL, '["python","functions","project"]', 18, true);

-- ── Python Lessons – Level 2 Chapter 1 ───────────────────────────────────────
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES
  ('py-l2-c1-l1', 'py-l2-c1', 'python', 'Lists Deep Dive',       'Slicing, comprehensions and methods',         'theory', 'intermediate', 1, 60, 12, '# Lists\n\n```python\nnums = [1,2,3,4,5]\nprint(nums[1:3])   # [2,3]\nsquares = [x**2 for x in nums]\nprint(squares)     # [1,4,9,16,25]\n```', '["python","lists","comprehension"]', 15, true),
  ('py-l2-c1-l2', 'py-l2-c1', 'python', 'Dictionaries',          'Key-value pairs and common operations',       'theory', 'intermediate', 2, 60, 12, '# Dictionaries\n\n```python\nuser = {"name": "Alex", "xp": 500}\nuser["level"] = 3\nfor key, value in user.items():\n    print(f"{key}: {value}")\n```', '["python","dict","hashmap"]', 15, true),
  ('py-l2-c1-l3', 'py-l2-c1', 'python', 'Tuples & Sets',         'Immutable sequences and unique collections',  'theory', 'intermediate', 3, 60, 12, '# Tuples & Sets\n\n```python\ncoords = (10, 20)  # tuple, immutable\nunique = {1, 2, 2, 3}  # {1,2,3}\n```', '["python","tuple","set"]', 12, true),
  ('py-l2-c1-l4', 'py-l2-c1', 'python', 'Word Frequency Counter','Count word occurrences using a dict',          'coding', 'intermediate', 4, 120, 25, NULL, '["python","dict","challenge"]', 20, true);

-- ── Python Lessons – Level 2 Chapter 2 ───────────────────────────────────────
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES
  ('py-l2-c2-l1', 'py-l2-c2', 'python', 'Classes & Objects',     'Define blueprints for your data',             'theory', 'intermediate', 1, 60, 12, '# Classes\n\n```python\nclass Hero:\n    def __init__(self, name, xp=0):\n        self.name = name\n        self.xp = xp\n\n    def level_up(self):\n        self.xp += 100\n        print(f"{self.name} levelled up!")\n```', '["python","class","oop"]', 18, true),
  ('py-l2-c2-l2', 'py-l2-c2', 'python', 'Inheritance',           'Reuse and extend existing classes',           'theory', 'intermediate', 2, 60, 12, '# Inheritance\n\n```python\nclass Mage(Hero):\n    def __init__(self, name):\n        super().__init__(name)\n        self.spells = []\n\n    def learn_spell(self, spell):\n        self.spells.append(spell)\n```', '["python","inheritance","oop"]', 18, true),
  ('py-l2-c2-l3', 'py-l2-c2', 'python', 'Special Methods',       'Dunder methods: __str__, __len__ and more',   'theory', 'intermediate', 3, 60, 12, '# Special Methods\n\n```python\nclass Vector:\n    def __init__(self, x, y):\n        self.x, self.y = x, y\n\n    def __repr__(self):\n        return f"Vector({self.x}, {self.y})"\n\n    def __add__(self, other):\n        return Vector(self.x+other.x, self.y+other.y)\n```', '["python","dunder","oop"]', 15, true),
  ('py-l2-c2-l4', 'py-l2-c2', 'python', 'RPG Character System',  'Build an OOP-based character class system',   'coding', 'intermediate', 4, 120, 25, NULL, '["python","oop","project"]', 25, true);

-- ── Python Lessons – Level 2 Chapter 3 ───────────────────────────────────────
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES
  ('py-l2-c3-l1', 'py-l2-c3', 'python', 'Reading Files',         'Open and read text and CSV files',            'theory', 'intermediate', 1, 60, 12, '# File Reading\n\n```python\nwith open("data.txt", "r") as f:\n    content = f.read()\n    # or: for line in f:\n```', '["python","file","io"]', 12, true),
  ('py-l2-c3-l2', 'py-l2-c3', 'python', 'Writing Files',         'Create and write to files',                   'theory', 'intermediate', 2, 60, 12, '# File Writing\n\n```python\nwith open("output.txt", "w") as f:\n    f.write("Hello, file!\n")\n    f.writelines(["line1\n","line2\n"])\n```', '["python","file","write"]', 12, true),
  ('py-l2-c3-l3', 'py-l2-c3', 'python', 'Exception Handling',    'try/except/finally patterns',                  'theory', 'intermediate', 3, 60, 12, '# Exceptions\n\n```python\ntry:\n    result = 10 / 0\nexcept ZeroDivisionError as e:\n    print(f"Error: {e}")\nfinally:\n    print("Always runs")\n```', '["python","exceptions","try"]', 15, true),
  ('py-l2-c3-l4', 'py-l2-c3', 'python', 'CSV Log Analyser',      'Parse a CSV file and report statistics',      'coding', 'intermediate', 4, 120, 25, NULL, '["python","csv","project"]', 25, true);

-- ── Python Lessons – Level 3 ─────────────────────────────────────────────────
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES
  ('py-l3-c1-l1', 'py-l3-c1', 'python', 'Big O Notation',        'Measure algorithm efficiency',                'theory', 'advanced', 1, 80, 18, '# Big O\n\nDescribes how runtime grows with input size.\n\n| Notation | Name         |\n|----------|--------------|\n| O(1)     | Constant     |\n| O(log n) | Logarithmic  |\n| O(n)     | Linear       |\n| O(n²)    | Quadratic    |', '["algorithms","complexity","bigo"]', 20, true),
  ('py-l3-c1-l2', 'py-l3-c1', 'python', 'Sorting Algorithms',    'Bubble, merge and quicksort in Python',       'theory', 'advanced', 2, 80, 18, '# Sorting\n\n```python\ndef merge_sort(arr):\n    if len(arr) <= 1:\n        return arr\n    mid = len(arr) // 2\n    left = merge_sort(arr[:mid])\n    right = merge_sort(arr[mid:])\n    return merge(left, right)\n```', '["python","sorting","algorithms"]', 25, true),
  ('py-l3-c1-l3', 'py-l3-c1', 'python', 'Binary Search',         'Efficient searching in sorted arrays',        'theory', 'advanced', 3, 80, 18, '# Binary Search\n\n```python\ndef binary_search(arr, target):\n    lo, hi = 0, len(arr) - 1\n    while lo <= hi:\n        mid = (lo + hi) // 2\n        if arr[mid] == target: return mid\n        elif arr[mid] < target: lo = mid + 1\n        else: hi = mid - 1\n    return -1\n```', '["python","search","binary"]', 20, true),
  ('py-l3-c1-l4', 'py-l3-c1', 'python', 'Two-Sum Challenge',     'Solve the classic two-sum problem optimally', 'coding', 'advanced', 4, 200, 40, NULL, '["python","hashmap","leetcode"]', 30, true),
  ('py-l3-c2-l1', 'py-l3-c2', 'python', 'Decorators',            'Wrap functions to add behaviour',             'theory', 'expert', 1, 80, 18, '# Decorators\n\n```python\nimport time\n\ndef timer(func):\n    def wrapper(*args, **kwargs):\n        start = time.time()\n        result = func(*args, **kwargs)\n        print(f"Elapsed: {time.time()-start:.4f}s")\n        return result\n    return wrapper\n\n@timer\ndef slow_func():\n    time.sleep(1)\n```', '["python","decorators","advanced"]', 20, true),
  ('py-l3-c2-l2', 'py-l3-c2', 'python', 'Generators',            'Lazy sequences with yield',                   'theory', 'expert', 2, 80, 18, '# Generators\n\n```python\ndef fibonacci():\n    a, b = 0, 1\n    while True:\n        yield a\n        a, b = b, a + b\n\nfib = fibonacci()\nprint([next(fib) for _ in range(8)])\n```', '["python","generators","yield"]', 18, true),
  ('py-l3-c2-l3', 'py-l3-c2', 'python', 'Context Managers',      'with statement and __enter__/__exit__',       'theory', 'expert', 3, 80, 18, '# Context Managers\n\n```python\nfrom contextlib import contextmanager\n\n@contextmanager\ndef managed_resource():\n    print("Acquiring")\n    yield\n    print("Releasing")\n\nwith managed_resource():\n    print("Using resource")\n```', '["python","contextmanager","advanced"]', 15, true),
  ('py-l3-c2-l4', 'py-l3-c2', 'python', 'Rate Limiter Decorator','Build a rate-limiting decorator',              'coding', 'expert', 4, 200, 40, NULL, '["python","decorator","project"]', 35, true),
  ('py-l3-c3-l1', 'py-l3-c3', 'python', 'Threading Basics',      'Concurrent execution with threads',           'theory', 'expert', 1, 80, 18, '# Threading\n\n```python\nimport threading\n\ndef worker(n):\n    print(f"Thread {n} running")\n\nthreads = [threading.Thread(target=worker, args=(i,)) for i in range(5)]\nfor t in threads:\n    t.start()\nfor t in threads:\n    t.join()\n```', '["python","threading","concurrency"]', 20, true),
  ('py-l3-c3-l2', 'py-l3-c3', 'python', 'asyncio Fundamentals',  'async/await and the event loop',              'theory', 'expert', 2, 80, 18, '# asyncio\n\n```python\nimport asyncio\n\nasync def fetch_data(url):\n    await asyncio.sleep(1)  # simulate network\n    return f"data from {url}"\n\nasync def main():\n    results = await asyncio.gather(\n        fetch_data("url1"),\n        fetch_data("url2"),\n    )\n    print(results)\n\nasyncio.run(main())\n```', '["python","asyncio","async"]', 25, true),
  ('py-l3-c3-l3', 'py-l3-c3', 'python', 'GIL & Multiprocessing', 'Bypass the GIL for CPU-bound work',          'theory', 'expert', 3, 80, 18, '# Multiprocessing\n\n```python\nfrom multiprocessing import Pool\n\ndef square(n):\n    return n * n\n\nwith Pool(4) as pool:\n    results = pool.map(square, range(10))\nprint(results)\n```', '["python","multiprocessing","performance"]', 20, true),
  ('py-l3-c3-l4', 'py-l3-c3', 'python', 'Async Web Scraper',     'Build a concurrent web scraper with aiohttp', 'coding', 'expert', 4, 250, 50, NULL, '["python","asyncio","project"]', 40, true);

-- =============================================================================
--  JAVASCRIPT
-- =============================================================================

INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES
  ('js-l1-c1', 'javascript', 'JS Fundamentals',       'Variables, types and first scripts',              1, 0, 4, '⚡', true),
  ('js-l1-c2', 'javascript', 'Control Flow & Loops',  'Conditions, for/while loops',                    2, 0, 4, '🔄', true),
  ('js-l1-c3', 'javascript', 'Functions',             'Declarations, expressions and arrow functions',   3, 0, 4, '🎯', true),
  ('js-l2-c1', 'javascript', 'Arrays & Objects',      'Collections, destructuring and spread',           4, 1, 4, '📚', true),
  ('js-l2-c2', 'javascript', 'DOM Manipulation',      'Select, create and modify HTML elements',         5, 1, 4, '🌐', true),
  ('js-l2-c3', 'javascript', 'Async JavaScript',      'Callbacks, Promises and async/await',             6, 1, 4, '⏳', true),
  ('js-l3-c1', 'javascript', 'Closures & Prototypes', 'Scope chains, closures and the prototype chain',  7, 2, 4, '🔗', true),
  ('js-l3-c2', 'javascript', 'ES6+ Features',         'Modules, generators, proxy and reflect',          8, 2, 4, '🚀', true),
  ('js-l3-c3', 'javascript', 'Functional Programming','map, filter, reduce and pure functions',           9, 2, 4, '♾️', true);

INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES
  ('js-l1-c1-l1','js-l1-c1','javascript','Hello JS',           'Your first JavaScript program',          'theory','beginner',1,50,10,'# Hello JavaScript\n\n```js\nconsole.log("Hello, World!");\n```\n\nJavaScript runs in the browser and Node.js.','["js","basics"]',10,true),
  ('js-l1-c1-l2','js-l1-c1','javascript','Variables & Types',  'var, let, const and JS data types',      'theory','beginner',2,50,10,'# Variables\n\n```js\nlet name = "Alex";   // reassignable\nconst XP = 500;       // constant\nvar legacy = true;    // old way\n```','["js","variables","types"]',12,true),
  ('js-l1-c1-l3','js-l1-c1','javascript','Types Quiz',         'Test your types knowledge',              'quiz','beginner',3,30,8,NULL,'["js","quiz"]',8,true),
  ('js-l1-c1-l4','js-l1-c1','javascript','String Operations',  'Manipulate and format strings',          'coding','beginner',4,100,20,NULL,'["js","strings","challenge"]',15,true),
  ('js-l1-c2-l1','js-l1-c2','javascript','if / else',          'Conditional logic in JavaScript',        'theory','beginner',1,50,10,'# Conditions\n\n```js\nif (score >= 90) {\n  console.log("A");\n} else if (score >= 70) {\n  console.log("B");\n} else {\n  console.log("Try harder");\n}\n```','["js","if","conditions"]',12,true),
  ('js-l1-c2-l2','js-l1-c2','javascript','for Loops',          'Iterate with for and for...of',          'theory','beginner',2,50,10,'# for Loops\n\n```js\nfor (let i = 0; i < 5; i++) {\n  console.log(i);\n}\n\nconst arr = [10, 20, 30];\nfor (const v of arr) console.log(v);\n```','["js","loops","for"]',12,true),
  ('js-l1-c2-l3','js-l1-c2','javascript','while Loops',        'Loop with conditions',                   'theory','beginner',3,50,10,'# while\n\n```js\nlet n = 0;\nwhile (n < 5) {\n  console.log(n++);\n}\n```','["js","while","loops"]',10,true),
  ('js-l1-c2-l4','js-l1-c2','javascript','FizzBuzz JS',        'Classic loop challenge',                 'coding','beginner',4,100,20,NULL,'["js","loops","fizzbuzz"]',15,true),
  ('js-l1-c3-l1','js-l1-c3','javascript','Function Declarations','Define and call functions',            'theory','beginner',1,50,10,'# Functions\n\n```js\nfunction add(a, b) {\n  return a + b;\n}\nconsole.log(add(3, 4)); // 7\n```','["js","functions"]',12,true),
  ('js-l1-c3-l2','js-l1-c3','javascript','Arrow Functions',    'Concise ES6 syntax',                     'theory','beginner',2,50,10,'# Arrow Functions\n\n```js\nconst multiply = (a, b) => a * b;\nconst square = n => n * n;\n```','["js","arrow","es6"]',10,true),
  ('js-l1-c3-l3','js-l1-c3','javascript','Higher-Order Funcs', 'Functions as arguments and returns',     'theory','beginner',3,50,10,'# Higher-Order Functions\n\n```js\nfunction applyTwice(fn, x) {\n  return fn(fn(x));\n}\nconsole.log(applyTwice(x => x * 2, 3)); // 12\n```','["js","hof","functional"]',12,true),
  ('js-l1-c3-l4','js-l1-c3','javascript','Callback Counter',   'Build a counter using callbacks',        'coding','beginner',4,100,20,NULL,'["js","callbacks","challenge"]',18,true),
  ('js-l2-c1-l1','js-l2-c1','javascript','Array Methods',      'map, filter, reduce, find, some, every', 'theory','intermediate',1,60,12,'# Array Methods\n\n```js\nconst nums = [1,2,3,4,5];\nconst evens = nums.filter(n => n % 2 === 0);\nconst doubled = nums.map(n => n * 2);\nconst sum = nums.reduce((acc,n) => acc+n, 0);\n```','["js","array","methods"]',15,true),
  ('js-l2-c1-l2','js-l2-c1','javascript','Destructuring',      'Unpack arrays and objects',               'theory','intermediate',2,60,12,'# Destructuring\n\n```js\nconst [a, b, ...rest] = [1, 2, 3, 4];\nconst { name, level = 1 } = user;\n```','["js","destructuring","es6"]',12,true),
  ('js-l2-c1-l3','js-l2-c1','javascript','Spread & Rest',      'Spread operator and rest parameters',    'theory','intermediate',3,60,12,'# Spread & Rest\n\n```js\nconst arr1 = [1,2];\nconst arr2 = [...arr1, 3, 4];\n\nfunction sum(...nums) {\n  return nums.reduce((a,n) => a+n, 0);\n}\n```','["js","spread","rest"]',12,true),
  ('js-l2-c1-l4','js-l2-c1','javascript','Data Pipeline',      'Chain array methods to process data',    'coding','intermediate',4,120,25,NULL,'["js","array","pipeline"]',20,true),
  ('js-l2-c2-l1','js-l2-c2','javascript','DOM Selection',      'querySelector and getElementById',       'theory','intermediate',1,60,12,'# DOM Selection\n\n```js\nconst btn = document.querySelector("#submit");\nconst items = document.querySelectorAll(".item");\n```','["js","dom","selection"]',12,true),
  ('js-l2-c2-l2','js-l2-c2','javascript','Modifying DOM',      'Change text, style and attributes',      'theory','intermediate',2,60,12,'# DOM Modification\n\n```js\nbtn.textContent = "Click me";\nbtn.style.color = "cyan";\nbtn.setAttribute("data-id", "42");\n```','["js","dom","modify"]',12,true),
  ('js-l2-c2-l3','js-l2-c2','javascript','Events',             'click, input, keydown event listeners',  'theory','intermediate',3,60,12,'# Events\n\n```js\nbtn.addEventListener("click", (e) => {\n  console.log("Clicked!", e.target);\n});\n```','["js","events","dom"]',15,true),
  ('js-l2-c2-l4','js-l2-c2','javascript','Todo List App',      'Build a DOM-based todo list',            'coding','intermediate',4,120,25,NULL,'["js","dom","project"]',25,true),
  ('js-l2-c3-l1','js-l2-c3','javascript','Callbacks',          'Asynchronous callbacks pattern',         'theory','intermediate',1,60,12,'# Callbacks\n\n```js\nsetTimeout(() => console.log("later"), 1000);\n\nfunction fetchData(cb) {\n  cb("result");\n}\nfetchData(data => console.log(data));\n```','["js","async","callbacks"]',12,true),
  ('js-l2-c3-l2','js-l2-c3','javascript','Promises',           'Promise chaining and error handling',    'theory','intermediate',2,60,12,'# Promises\n\n```js\nfetch("/api/data")\n  .then(res => res.json())\n  .then(data => console.log(data))\n  .catch(err => console.error(err));\n```','["js","promises","async"]',15,true),
  ('js-l2-c3-l3','js-l2-c3','javascript','async / await',      'Modern async syntax',                    'theory','intermediate',3,60,12,'# async/await\n\n```js\nasync function getData() {\n  try {\n    const res = await fetch("/api");\n    const data = await res.json();\n    return data;\n  } catch (e) {\n    console.error(e);\n  }\n}\n```','["js","async","await"]',15,true),
  ('js-l2-c3-l4','js-l2-c3','javascript','Weather API Client', 'Fetch and display weather data',         'coding','intermediate',4,120,25,NULL,'["js","fetch","project"]',25,true),
  ('js-l3-c1-l1','js-l3-c1','javascript','Closures',           'Lexical scope and closure patterns',     'theory','advanced',1,80,18,'# Closures\n\n```js\nfunction counter() {\n  let count = 0;\n  return {\n    increment: () => ++count,\n    get: () => count,\n  };\n}\nconst c = counter();\nc.increment(); c.increment();\nconsole.log(c.get()); // 2\n```','["js","closures","scope"]',20,true),
  ('js-l3-c1-l2','js-l3-c1','javascript','Prototype Chain',    'Object prototypes and inheritance',      'theory','advanced',2,80,18,'# Prototypes\n\n```js\nfunction Animal(name) { this.name = name; }\nAnimal.prototype.speak = function() {\n  console.log(`${this.name} speaks`);\n};\nconst dog = new Animal("Rex");\ndog.speak();\n```','["js","prototype","oop"]',20,true),
  ('js-l3-c1-l3','js-l3-c1','javascript','this Keyword',       'Understanding this in different contexts','theory','advanced',3,80,18,'# this\n\n```js\nconst obj = {\n  name: "Hero",\n  greet() { console.log(this.name); },\n  arrowGreet: () => console.log(this), // undefined in strict mode\n};\n```','["js","this","context"]',18,true),
  ('js-l3-c1-l4','js-l3-c1','javascript','Memoization',        'Cache expensive function results',       'coding','advanced',4,200,40,NULL,'["js","memoization","performance"]',30,true),
  ('js-l3-c2-l1','js-l3-c2','javascript','ES Modules',         'import/export syntax and module patterns','theory','expert',1,80,18,'# Modules\n\n```js\n// math.js\nexport const add = (a,b) => a+b;\nexport default function multiply(a,b) { return a*b; }\n\n// main.js\nimport multiply, { add } from "./math.js";\n```','["js","modules","es6"]',15,true),
  ('js-l3-c2-l2','js-l3-c2','javascript','Generators & Iterators','function* and custom iterables',      'theory','expert',2,80,18,'# Generators\n\n```js\nfunction* range(start, end) {\n  for (let i = start; i < end; i++) yield i;\n}\nfor (const n of range(0, 5)) console.log(n);\n```','["js","generators","iterators"]',20,true),
  ('js-l3-c2-l3','js-l3-c2','javascript','Proxy & Reflect',    'Intercept object operations',            'theory','expert',3,80,18,'# Proxy\n\n```js\nconst handler = {\n  get(target, key) {\n    return key in target ? target[key] : `${key} not found`;\n  },\n};\nconst p = new Proxy({}, handler);\np.name = "Alex";\nconsole.log(p.name);    // Alex\nconsole.log(p.missing); // missing not found\n```','["js","proxy","metaprogramming"]',20,true),
  ('js-l3-c2-l4','js-l3-c2','javascript','Observable Stream',  'Build a simple observable from scratch',  'coding','expert',4,200,40,NULL,'["js","observable","rxjs-concepts"]',40,true),
  ('js-l3-c3-l1','js-l3-c3','javascript','Pure Functions',     'Side effects, referential transparency',  'theory','expert',1,80,18,'# Pure Functions\n\n```js\n// Pure\nconst add = (a,b) => a+b;\n\n// Impure (modifies external state)\nlet total = 0;\nconst addToTotal = n => { total += n; };\n```','["js","functional","pure"]',15,true),
  ('js-l3-c3-l2','js-l3-c3','javascript','map / filter / reduce','Functional data transformations',      'theory','expert',2,80,18,'# Functional Trio\n\n```js\nconst data = [1,2,3,4,5];\nconst result = data\n  .filter(n => n % 2 !== 0)\n  .map(n => n * 3)\n  .reduce((sum, n) => sum + n, 0);\n// 1→3, 3→9, 5→15 → sum=27\n```','["js","map","filter","reduce"]',15,true),
  ('js-l3-c3-l3','js-l3-c3','javascript','Currying & Composition','Partial application and compose',    'theory','expert',3,80,18,'# Currying\n\n```js\nconst curry = fn => a => b => fn(a, b);\nconst add = curry((a,b) => a+b);\nconst add5 = add(5);\nconsole.log(add5(3)); // 8\n```','["js","currying","composition"]',18,true),
  ('js-l3-c3-l4','js-l3-c3','javascript','Functional Data Pipeline','Chain pure functions to transform data','coding','expert',4,250,50,NULL,'["js","functional","pipeline"]',35,true);

-- =============================================================================
--  DART
-- =============================================================================

INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES
  ('dart-l1-c1', 'dart', 'Dart Basics',          'Variables, types and null safety',              1, 0, 4, '🎯', true),
  ('dart-l1-c2', 'dart', 'Control Flow',         'Conditions, loops and switch',                   2, 0, 4, '🔀', true),
  ('dart-l1-c3', 'dart', 'Functions & Lambdas',  'Named, optional params, arrow syntax',           3, 0, 4, '⚙️', true),
  ('dart-l2-c1', 'dart', 'Collections',          'List, Map, Set and iterables',                   4, 1, 4, '📦', true),
  ('dart-l2-c2', 'dart', 'OOP in Dart',          'Classes, mixins, generics',                      5, 1, 4, '🏗️', true),
  ('dart-l2-c3', 'dart', 'Async Dart',           'Future, Stream and async/await',                 6, 1, 4, '⏳', true),
  ('dart-l3-c1', 'dart', 'Flutter Widgets',      'StatelessWidget, StatefulWidget lifecycle',      7, 2, 4, '📱', true),
  ('dart-l3-c2', 'dart', 'State Management',     'setState, InheritedWidget, Provider basics',     8, 2, 4, '🔄', true),
  ('dart-l3-c3', 'dart', 'Advanced Dart',        'Isolates, extension methods, meta',              9, 2, 4, '🚀', true);

INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES
  ('dart-l1-c1-l1','dart-l1-c1','dart','Hello Dart',         'Your first Dart program',               'theory','beginner',1,50,10,'# Hello Dart\n\n```dart\nvoid main() {\n  print(''Hello, World!'');\n}\n```','["dart","basics"]',10,true),
  ('dart-l1-c1-l2','dart-l1-c1','dart','Variables & Types',  'int, double, String, bool, var, dynamic','theory','beginner',2,50,10,'# Variables\n\n```dart\nint age = 20;\nString name = ''Alex'';\nbool isLearning = true;\nvar score = 95.5;   // inferred double\n```','["dart","types","variables"]',12,true),
  ('dart-l1-c1-l3','dart-l1-c1','dart','Null Safety',        'Nullable vs non-nullable types',        'theory','beginner',3,50,10,'# Null Safety\n\n```dart\nString name = ''Alex'';   // non-nullable\nString? nickname;        // nullable\nnickname ??= ''coder'';  // assign if null\nprint(name.length);     // safe\n```','["dart","null-safety","types"]',15,true),
  ('dart-l1-c1-l4','dart-l1-c1','dart','Temperature Converter','Build a unit converter',             'coding','beginner',4,100,20,NULL,'["dart","basics","challenge"]',15,true),
  ('dart-l1-c2-l1','dart-l1-c2','dart','if / else',          'Conditional expressions',               'theory','beginner',1,50,10,'# Conditions\n\n```dart\nint x = 10;\nif (x > 5) {\n  print(''big'');\n} else {\n  print(''small'');\n}\n```','["dart","if","conditions"]',12,true),
  ('dart-l1-c2-l2','dart-l1-c2','dart','for & while Loops',  'Iteration patterns in Dart',            'theory','beginner',2,50,10,'# Loops\n\n```dart\nfor (var i = 0; i < 5; i++) print(i);\n\nvar n = 0;\nwhile (n < 3) { print(n++); }\n```','["dart","loops"]',12,true),
  ('dart-l1-c2-l3','dart-l1-c2','dart','switch & Enums',     'Pattern matching and enumerations',     'theory','beginner',3,50,10,'# switch\n\n```dart\nenum Color { red, green, blue }\nvar c = Color.red;\nswitch(c) {\n  case Color.red: print(''red''); break;\n  default: print(''other'');\n}\n```','["dart","switch","enum"]',10,true),
  ('dart-l1-c2-l4','dart-l1-c2','dart','Number Guesser',     'Loop-based guessing game',              'coding','beginner',4,100,20,NULL,'["dart","loops","game"]',18,true),
  ('dart-l1-c3-l1','dart-l1-c3','dart','Functions',          'Define and call Dart functions',        'theory','beginner',1,50,10,'# Functions\n\n```dart\nint add(int a, int b) => a + b;\nvoid greet(String name) {\n  print(''Hello, $name!'');\n}\n```','["dart","functions"]',12,true),
  ('dart-l1-c3-l2','dart-l1-c3','dart','Optional Parameters', 'Named and positional optional params',  'theory','beginner',2,50,10,'# Optional Params\n\n```dart\nvoid log(String msg, {String level = ''INFO''}) {\n  print(''[$level] $msg'');\n}\nlog(''connected'');           // [INFO]\nlog(''error'', level: ''ERR''); // [ERR]\n```','["dart","parameters","optional"]',12,true),
  ('dart-l1-c3-l3','dart-l1-c3','dart','Lambdas & Closures', 'Anonymous functions and closures',      'theory','beginner',3,50,10,'# Lambdas\n\n```dart\nvar double = (int x) => x * 2;\nvar adder = (int n) => (int x) => x + n;\nvar add5 = adder(5);\nprint(add5(3)); // 8\n```','["dart","lambda","closure"]',12,true),
  ('dart-l1-c3-l4','dart-l1-c3','dart','Higher-Order Functions','map, where, fold on iterables',     'coding','beginner',4,100,20,NULL,'["dart","hof","iterable"]',18,true),
  ('dart-l2-c1-l1','dart-l2-c1','dart','Lists',              'Fixed and growable lists, methods',     'theory','intermediate',1,60,12,'# Lists\n\n```dart\nvar nums = [1, 2, 3];\nnums.add(4);\nvar doubled = nums.map((n) => n * 2).toList();\n```','["dart","list","collections"]',15,true),
  ('dart-l2-c1-l2','dart-l2-c1','dart','Maps',               'Key-value pairs and operations',        'theory','intermediate',2,60,12,'# Maps\n\n```dart\nvar scores = <String, int>{''Alice'': 95, ''Bob'': 82};\nscores[''Charlie''] = 78;\nscores.forEach((k,v) => print(''$k: $v''));\n```','["dart","map","collections"]',15,true),
  ('dart-l2-c1-l3','dart-l2-c1','dart','Sets & Iterables',   'Unique elements and lazy iteration',    'theory','intermediate',3,60,12,'# Sets\n\n```dart\nvar tags = <String>{''flutter'', ''dart'', ''mobile''};\ntags.add(''flutter''); // no duplicate\nprint(tags.length); // 3\n```','["dart","set","iterable"]',12,true),
  ('dart-l2-c1-l4','dart-l2-c1','dart','Shopping Cart',      'Build a cart using List and Map',       'coding','intermediate',4,120,25,NULL,'["dart","collections","project"]',22,true),
  ('dart-l2-c2-l1','dart-l2-c2','dart','Classes in Dart',    'Constructors, fields, methods',         'theory','intermediate',1,60,12,'# Classes\n\n```dart\nclass Hero {\n  final String name;\n  int xp;\n  Hero(this.name, {this.xp = 0});\n  void gainXp(int amount) => xp += amount;\n}\n```','["dart","class","oop"]',18,true),
  ('dart-l2-c2-l2','dart-l2-c2','dart','Mixins',             'Add behaviour with mixins',              'theory','intermediate',2,60,12,'# Mixins\n\n```dart\nmixin Swimmer {\n  void swim() => print(''swimming'');\n}\nclass Duck extends Animal with Swimmer {}\nDuck().swim();\n```','["dart","mixin","oop"]',15,true),
  ('dart-l2-c2-l3','dart-l2-c2','dart','Generics',           'Type-safe collections and functions',   'theory','intermediate',3,60,12,'# Generics\n\n```dart\nclass Box<T> {\n  T value;\n  Box(this.value);\n  T get() => value;\n}\nvar box = Box<int>(42);\n```','["dart","generics","types"]',15,true),
  ('dart-l2-c2-l4','dart-l2-c2','dart','Generic Stack',      'Implement a typed stack class',         'coding','intermediate',4,120,25,NULL,'["dart","generics","data-structure"]',22,true),
  ('dart-l2-c3-l1','dart-l2-c3','dart','Future & async',     'Async operations and awaiting results', 'theory','intermediate',1,60,12,'# Future\n\n```dart\nFuture<String> fetchData() async {\n  await Future.delayed(Duration(seconds: 1));\n  return ''data'';\n}\nvoid main() async {\n  var result = await fetchData();\n  print(result);\n}\n```','["dart","future","async"]',15,true),
  ('dart-l2-c3-l2','dart-l2-c3','dart','Streams',            'Reactive sequences of data',            'theory','intermediate',2,60,12,'# Streams\n\n```dart\nStream<int> counter(int max) async* {\n  for (var i = 0; i < max; i++) {\n    await Future.delayed(Duration(seconds: 1));\n    yield i;\n  }\n}\n```','["dart","stream","reactive"]',18,true),
  ('dart-l2-c3-l3','dart-l2-c3','dart','Error Handling',     'try/catch/finally in async Dart',       'theory','intermediate',3,60,12,'# Errors\n\n```dart\ntry {\n  var result = await riskyOperation();\n} on NetworkException catch (e) {\n  print(''Network error: $e'');\n} finally {\n  cleanup();\n}\n```','["dart","error","exception"]',12,true),
  ('dart-l2-c3-l4','dart-l2-c3','dart','Timer Stream App',   'Stream-based countdown timer',          'coding','intermediate',4,120,25,NULL,'["dart","stream","project"]',25,true),
  ('dart-l3-c1-l1','dart-l3-c1','dart','StatelessWidget',    'Build immutable Flutter widgets',        'theory','advanced',1,80,18,'# StatelessWidget\n\n```dart\nclass GreetCard extends StatelessWidget {\n  final String name;\n  const GreetCard({super.key, required this.name});\n  @override\n  Widget build(BuildContext ctx) =>\n    Text(''Hello, $name!'');\n}\n```','["dart","flutter","stateless"]',20,true),
  ('dart-l3-c1-l2','dart-l3-c1','dart','StatefulWidget',     'Mutable state with setState',            'theory','advanced',2,80,18,'# StatefulWidget\n\n```dart\nclass Counter extends StatefulWidget {\n  const Counter({super.key});\n  @override\n  State<Counter> createState() => _CounterState();\n}\nclass _CounterState extends State<Counter> {\n  int _count = 0;\n  @override\n  Widget build(BuildContext ctx) =>\n    ElevatedButton(\n      onPressed: () => setState(() => _count++),\n      child: Text(''$_count''),\n    );\n}\n```','["dart","flutter","stateful"]',20,true),
  ('dart-l3-c1-l3','dart-l3-c1','dart','Widget Lifecycle',   'initState, didUpdate, dispose',          'theory','advanced',3,80,18,'# Lifecycle\n\n```dart\n@override\nvoid initState() {\n  super.initState();\n  // one-time setup\n}\n@override\nvoid dispose() {\n  controller.dispose();\n  super.dispose();\n}\n```','["dart","flutter","lifecycle"]',18,true),
  ('dart-l3-c1-l4','dart-l3-c1','dart','Custom Widget Challenge','Build a reusable neon card widget', 'coding','advanced',4,200,40,NULL,'["dart","flutter","widget"]',30,true),
  ('dart-l3-c2-l1','dart-l3-c2','dart','setState Deep Dive',  'When and how setState rebuilds',        'theory','expert',1,80,18,'# setState\n\nCalling setState() schedules a rebuild. Minimise the scope to avoid unnecessary rebuilds.\n\n```dart\nvoid _toggle() {\n  setState(() { _isOn = !_isOn; });\n}\n```','["dart","state","flutter"]',15,true),
  ('dart-l3-c2-l2','dart-l3-c2','dart','InheritedWidget',    'Share state down the widget tree',       'theory','expert',2,80,18,'# InheritedWidget\n\nBase for state management solutions like Provider.\n\n```dart\nclass AppState extends InheritedWidget {\n  final int xp;\n  ...\n  static AppState of(BuildContext ctx) =>\n    ctx.dependOnInheritedWidgetOfExactType<AppState>()!;\n}\n```','["dart","inheritedwidget","state"]',20,true),
  ('dart-l3-c2-l3','dart-l3-c2','dart','Provider Basics',    'Simple state with the Provider package', 'theory','expert',3,80,18,'# Provider\n\n```dart\nChangeNotifierProvider(\n  create: (_) => Counter(),\n  child: MyApp(),\n);\n\n// Consume:\nfinal counter = context.watch<Counter>();\n```','["dart","provider","state"]',20,true),
  ('dart-l3-c2-l4','dart-l3-c2','dart','Theme Toggle App',   'Dark/light mode using Provider',         'coding','expert',4,200,40,NULL,'["dart","provider","theme"]',35,true),
  ('dart-l3-c3-l1','dart-l3-c3','dart','Isolates',           'True parallelism in Dart',               'theory','expert',1,80,18,'# Isolates\n\n```dart\nimport ''dart:isolate'';\n\nvoid heavyWork(SendPort port) {\n  port.send(42);\n}\nvoid main() async {\n  final port = ReceivePort();\n  await Isolate.spawn(heavyWork, port.sendPort);\n  final result = await port.first;\n  print(result);\n}\n```','["dart","isolate","concurrency"]',25,true),
  ('dart-l3-c3-l2','dart-l3-c3','dart','Extension Methods',  'Add methods to existing types',          'theory','expert',2,80,18,'# Extensions\n\n```dart\nextension StringX on String {\n  String get capitalised =>\n    isEmpty ? this : this[0].toUpperCase() + substring(1);\n}\n\nprint(''hello''.capitalised); // Hello\n```','["dart","extension","advanced"]',15,true),
  ('dart-l3-c3-l3','dart-l3-c3','dart','Metadata & Annotations','@annotations and reflection',        'theory','expert',3,80,18,'# Annotations\n\n```dart\nclass Route {\n  final String path;\n  const Route(this.path);\n}\n\n@Route(''/home'')\nclass HomeScreen extends StatelessWidget { ... }\n```','["dart","annotations","meta"]',15,true),
  ('dart-l3-c3-l4','dart-l3-c3','dart','Isolate Pool',       'Task queue using Isolate pool',          'coding','expert',4,250,50,NULL,'["dart","isolate","project"]',40,true);

-- =============================================================================
--  JAVA
-- =============================================================================

INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES
  ('java-l1-c1','java','Java Basics',       'Syntax, types and first program',              1,0,4,'☕',true),
  ('java-l1-c2','java','Control Flow',      'if, for, while, switch',                       2,0,4,'🔀',true),
  ('java-l1-c3','java','Methods & Scope',   'Method definition and variable scope',          3,0,4,'⚙️',true),
  ('java-l2-c1','java','OOP Foundations',   'Classes, objects, constructors',               4,1,4,'🏗️',true),
  ('java-l2-c2','java','Inheritance & Interfaces','extends, implements, polymorphism',       5,1,4,'🧬',true),
  ('java-l2-c3','java','Collections Framework','ArrayList, HashMap, LinkedList',            6,1,4,'📦',true),
  ('java-l3-c1','java','Exception Handling','try/catch, custom exceptions, finally',        7,2,4,'🛡️',true),
  ('java-l3-c2','java','Generics & Lambdas','Type parameters, functional interfaces',       8,2,4,'🔬',true),
  ('java-l3-c3','java','Streams & Concurrency','Stream API, threads, ExecutorService',      9,2,4,'⚡',true);

INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES
  ('java-l1-c1-l1','java-l1-c1','java','Hello Java',        'First Java program',                      'theory','beginner',1,50,10,'# Hello Java\n\n```java\npublic class Main {\n    public static void main(String[] args) {\n        System.out.println("Hello, World!");\n    }\n}\n```','["java","basics"]',10,true),
  ('java-l1-c1-l2','java-l1-c1','java','Primitive Types',   'int, double, char, boolean',              'theory','beginner',2,50,10,'# Primitives\n\n```java\nint age = 20;\ndouble gpa = 3.9;\nchar grade = ''A'';\nboolean active = true;\nString name = "Alex"; // reference type\n```','["java","types","primitives"]',12,true),
  ('java-l1-c1-l3','java-l1-c1','java','Operators Quiz',    'Test arithmetic and logical operators',   'quiz','beginner',3,30,8,NULL,'["java","quiz","operators"]',8,true),
  ('java-l1-c1-l4','java-l1-c1','java','Unit Converter',    'Build a metric/imperial converter',        'coding','beginner',4,100,20,NULL,'["java","basics","challenge"]',15,true),
  ('java-l1-c2-l1','java-l1-c2','java','if / else',         'Conditional branching',                   'theory','beginner',1,50,10,'# Conditions\n\n```java\nif (score >= 90) {\n    System.out.println("A");\n} else if (score >= 70) {\n    System.out.println("B");\n} else {\n    System.out.println("C");\n}\n```','["java","if","conditionals"]',12,true),
  ('java-l1-c2-l2','java-l1-c2','java','for Loops',         'for and enhanced for-each',               'theory','beginner',2,50,10,'# Loops\n\n```java\nfor (int i = 0; i < 5; i++) {\n    System.out.println(i);\n}\nint[] arr = {10, 20, 30};\nfor (int n : arr) System.out.println(n);\n```','["java","for","loops"]',12,true),
  ('java-l1-c2-l3','java-l1-c2','java','while & do-while', 'Condition-driven loops',                  'theory','beginner',3,50,10,'# while\n\n```java\nint n = 0;\nwhile (n < 5) System.out.println(n++);\n\ndo {\n    System.out.println("at least once");\n} while (false);\n```','["java","while","dowhile"]',10,true),
  ('java-l1-c2-l4','java-l1-c2','java','Pyramid Pattern',  'Print patterns using nested loops',        'coding','beginner',4,100,20,NULL,'["java","loops","pattern"]',15,true),
  ('java-l1-c3-l1','java-l1-c3','java','Methods',           'Define and call static methods',           'theory','beginner',1,50,10,'# Methods\n\n```java\nstatic int add(int a, int b) {\n    return a + b;\n}\n\nstatic void greet(String name) {\n    System.out.println("Hi, " + name);\n}\n```','["java","methods","static"]',12,true),
  ('java-l1-c3-l2','java-l1-c3','java','Method Overloading','Same name, different parameters',         'theory','beginner',2,50,10,'# Overloading\n\n```java\nstatic double area(double radius) {\n    return Math.PI * radius * radius;\n}\nstatic double area(double w, double h) {\n    return w * h;\n}\n```','["java","overloading","methods"]',12,true),
  ('java-l1-c3-l3','java-l1-c3','java','Recursion',         'Solving problems with self-calls',        'theory','beginner',3,50,10,'# Recursion\n\n```java\nstatic int factorial(int n) {\n    return n <= 1 ? 1 : n * factorial(n - 1);\n}\n```','["java","recursion","methods"]',15,true),
  ('java-l1-c3-l4','java-l1-c3','java','Fibonacci Recursive','Print Fibonacci series recursively',     'coding','beginner',4,100,20,NULL,'["java","recursion","fibonacci"]',18,true),
  ('java-l2-c1-l1','java-l2-c1','java','Classes & Objects', 'Define classes and instantiate objects',  'theory','intermediate',1,60,12,'# Classes\n\n```java\npublic class Hero {\n    String name;\n    int xp;\n    Hero(String name) { this.name = name; }\n    void gainXp(int amount) { xp += amount; }\n}\nHero h = new Hero("Alex");\nh.gainXp(50);\n```','["java","class","oop"]',18,true),
  ('java-l2-c1-l2','java-l2-c1','java','Encapsulation',     'Private fields, getters and setters',     'theory','intermediate',2,60,12,'# Encapsulation\n\n```java\nprivate int _xp;\npublic int getXp() { return _xp; }\npublic void setXp(int v) {\n    if (v >= 0) _xp = v;\n}\n```','["java","encapsulation","oop"]',15,true),
  ('java-l2-c1-l3','java-l2-c1','java','Constructors',      'Default, parameterised, this()',          'theory','intermediate',3,60,12,'# Constructors\n\n```java\npublic class Point {\n    int x, y;\n    Point() { this(0, 0); }   // calls below\n    Point(int x, int y) { this.x=x; this.y=y; }\n}\n```','["java","constructor","oop"]',12,true),
  ('java-l2-c1-l4','java-l2-c1','java','Bank Account',      'Model a bank account with OOP',           'coding','intermediate',4,120,25,NULL,'["java","oop","project"]',22,true),
  ('java-l2-c2-l1','java-l2-c2','java','Inheritance',       'extends keyword and super',               'theory','intermediate',1,60,12,'# Inheritance\n\n```java\nclass Animal { void sound() {} }\nclass Dog extends Animal {\n    @Override\n    public void sound() { System.out.println("Woof"); }\n}\n```','["java","inheritance","extends"]',18,true),
  ('java-l2-c2-l2','java-l2-c2','java','Interfaces',        'Contract-based programming with implements','theory','intermediate',2,60,12,'# Interfaces\n\n```java\ninterface Drawable {\n    void draw();\n    default void show() { System.out.println("showing"); }\n}\nclass Circle implements Drawable {\n    public void draw() { System.out.println("O"); }\n}\n```','["java","interface","implements"]',15,true),
  ('java-l2-c2-l3','java-l2-c2','java','Abstract Classes',  'Abstract methods and template pattern',   'theory','intermediate',3,60,12,'# Abstract\n\n```java\nabstract class Shape {\n    abstract double area();\n    void describe() {\n        System.out.println("Area: " + area());\n    }\n}\n```','["java","abstract","oop"]',15,true),
  ('java-l2-c2-l4','java-l2-c2','java','Shape Hierarchy',   'Build polymorphic shape hierarchy',        'coding','intermediate',4,120,25,NULL,'["java","polymorphism","project"]',25,true),
  ('java-l2-c3-l1','java-l2-c3','java','ArrayList',         'Dynamic arrays with ArrayList',           'theory','intermediate',1,60,12,'# ArrayList\n\n```java\nList<String> names = new ArrayList<>();\nnames.add("Alice");\nnames.add("Bob");\nnames.sort(null);\nnames.forEach(System.out::println);\n```','["java","arraylist","collections"]',15,true),
  ('java-l2-c3-l2','java-l2-c3','java','HashMap',           'Key-value storage with HashMap',           'theory','intermediate',2,60,12,'# HashMap\n\n```java\nMap<String,Integer> scores = new HashMap<>();\nscores.put("Alice", 95);\nscores.getOrDefault("Bob", 0);\nscores.entrySet().forEach(e ->\n    System.out.println(e.getKey()+": "+e.getValue()));\n```','["java","hashmap","collections"]',15,true),
  ('java-l2-c3-l3','java-l2-c3','java','LinkedList & Queue','Deque operations with LinkedList',        'theory','intermediate',3,60,12,'# LinkedList\n\n```java\nDeque<Integer> stack = new LinkedList<>();\nstack.push(1); stack.push(2);\nSystem.out.println(stack.pop()); // 2 (LIFO)\n```','["java","linkedlist","deque"]',15,true),
  ('java-l2-c3-l4','java-l2-c3','java','Phonebook App',     'Contact manager using HashMap',           'coding','intermediate',4,120,25,NULL,'["java","hashmap","project"]',22,true),
  ('java-l3-c1-l1','java-l3-c1','java','try / catch',       'Handle checked and unchecked exceptions',  'theory','advanced',1,80,18,'# Exceptions\n\n```java\ntry {\n    int result = 10 / 0;\n} catch (ArithmeticException e) {\n    System.out.println("Caught: " + e.getMessage());\n} finally {\n    System.out.println("Done");\n}\n```','["java","exceptions","try"]',15,true),
  ('java-l3-c1-l2','java-l3-c1','java','Custom Exceptions', 'Define domain-specific exception types',   'theory','advanced',2,80,18,'# Custom Exceptions\n\n```java\nclass InsufficientFundsException extends Exception {\n    InsufficientFundsException(double amount) {\n        super("Need " + amount + " more");\n    }\n}\n```','["java","custom-exception","advanced"]',15,true),
  ('java-l3-c1-l3','java-l3-c1','java','Multi-catch & Resources','Multi-catch and try-with-resources','theory','advanced',3,80,18,'# Multi-catch\n\n```java\ntry (BufferedReader br = new BufferedReader(new FileReader("f.txt"))) {\n    String line;\n    while ((line = br.readLine()) != null) System.out.println(line);\n} catch (IOException | NullPointerException e) {\n    e.printStackTrace();\n}\n```','["java","multicatch","resources"]',18,true),
  ('java-l3-c1-l4','java-l3-c1','java','Safe JSON Parser',  'Parse JSON with exception safety',         'coding','advanced',4,200,40,NULL,'["java","json","exception"]',30,true),
  ('java-l3-c2-l1','java-l3-c2','java','Generics',          'Type-safe classes and methods',           'theory','advanced',1,80,18,'# Generics\n\n```java\nclass Pair<A, B> {\n    A first; B second;\n    Pair(A a, B b) { first=a; second=b; }\n}\nPair<String,Integer> p = new Pair<>("hi", 42);\n```','["java","generics","types"]',18,true),
  ('java-l3-c2-l2','java-l3-c2','java','Lambda Expressions', 'Functional interfaces and lambdas',      'theory','advanced',2,80,18,'# Lambdas\n\n```java\nList<Integer> nums = List.of(3,1,4,1,5);\nnums.stream()\n    .sorted()\n    .forEach(System.out::println);\n```','["java","lambda","functional"]',18,true),
  ('java-l3-c2-l3','java-l3-c2','java','Method References',  'Shorthand lambda notation',               'theory','advanced',3,80,18,'# Method References\n\n```java\n// Type::method\nList<String> names = List.of("Charlie","Alice","Bob");\nnames.stream()\n     .sorted(String::compareTo)\n     .forEach(System.out::println);\n```','["java","method-ref","lambda"]',15,true),
  ('java-l3-c2-l4','java-l3-c2','java','Generic Stack',     'Implement a bounded generic stack',        'coding','advanced',4,200,40,NULL,'["java","generics","data-structure"]',28,true),
  ('java-l3-c3-l1','java-l3-c3','java','Stream API',        'filter, map, reduce, collect',             'theory','expert',1,80,18,'# Streams\n\n```java\nList<String> result = employees.stream()\n    .filter(e -> e.salary > 50000)\n    .map(Employee::getName)\n    .sorted()\n    .collect(Collectors.toList());\n```','["java","streams","functional"]',20,true),
  ('java-l3-c3-l2','java-l3-c3','java','Thread Basics',     'Runnable, Thread class, synchronised',     'theory','expert',2,80,18,'# Threads\n\n```java\nnew Thread(() -> {\n    System.out.println("Running in " + Thread.currentThread().getName());\n}).start();\n```','["java","thread","concurrency"]',20,true),
  ('java-l3-c3-l3','java-l3-c3','java','ExecutorService',   'Thread pools and Future tasks',            'theory','expert',3,80,18,'# ExecutorService\n\n```java\nExecutorService pool = Executors.newFixedThreadPool(4);\nFuture<Integer> f = pool.submit(() -> expensiveCalc());\nSystem.out.println(f.get());\npool.shutdown();\n```','["java","executor","concurrency"]',20,true),
  ('java-l3-c3-l4','java-l3-c3','java','Parallel Merge Sort','Concurrent sort using ForkJoinPool',     'coding','expert',4,250,50,NULL,'["java","forkjoin","algorithms"]',40,true);

-- =============================================================================
--  C++
-- =============================================================================

INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES
  ('cpp-l1-c1','cpp','C++ Fundamentals',    'Syntax, types and first program',             1,0,4,'⚙️',true),
  ('cpp-l1-c2','cpp','Control Flow',        'if, for, while, switch',                      2,0,4,'🔀',true),
  ('cpp-l1-c3','cpp','Functions & Arrays',  'Function definitions and arrays',              3,0,4,'📐',true),
  ('cpp-l2-c1','cpp','OOP in C++',          'Classes, constructors, destructors',           4,1,4,'🏗️',true),
  ('cpp-l2-c2','cpp','Pointers & Memory',   'Pointers, references, dynamic allocation',     5,1,4,'🧠',true),
  ('cpp-l2-c3','cpp','STL Containers',      'vector, map, set, queue, stack',               6,1,4,'📦',true),
  ('cpp-l3-c1','cpp','Templates',           'Function and class templates, specialisation', 7,2,4,'🔬',true),
  ('cpp-l3-c2','cpp','Move Semantics',      'rvalue refs, std::move, smart pointers',       8,2,4,'🚀',true),
  ('cpp-l3-c3','cpp','Concurrency',         'std::thread, mutex, future, async',            9,2,4,'⚡',true);

INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES
  ('cpp-l1-c1-l1','cpp-l1-c1','cpp','Hello C++',         'First C++ program',                         'theory','beginner',1,50,10,'# Hello C++\n\n```cpp\n#include <iostream>\nint main() {\n    std::cout << "Hello, World!" << std::endl;\n    return 0;\n}\n```','["cpp","basics","hello"]',10,true),
  ('cpp-l1-c1-l2','cpp-l1-c1','cpp','Variables & Types', 'int, double, char, bool, string',           'theory','beginner',2,50,10,'# Variables\n\n```cpp\nint age = 20;\ndouble gpa = 3.9;\nchar grade = ''A'';\nbool active = true;\nstd::string name = "Alex";\n```','["cpp","types","variables"]',12,true),
  ('cpp-l1-c1-l3','cpp-l1-c1','cpp','I/O Streams',       'cin, cout and stream operators',            'theory','beginner',3,50,10,'# I/O\n\n```cpp\n#include <iostream>\n#include <string>\nint main() {\n    std::string name;\n    std::cout << "Enter name: ";\n    std::cin >> name;\n    std::cout << "Hello, " << name << "!\n";\n}\n```','["cpp","cin","cout"]',12,true),
  ('cpp-l1-c1-l4','cpp-l1-c1','cpp','Simple Calculator',  'Arithmetic calculator in C++',              'coding','beginner',4,100,20,NULL,'["cpp","calculator","basics"]',15,true),
  ('cpp-l1-c2-l1','cpp-l1-c2','cpp','if / else',          'Conditional branching',                     'theory','beginner',1,50,10,'# Conditions\n\n```cpp\nif (x > 0) {\n    std::cout << "positive";\n} else if (x < 0) {\n    std::cout << "negative";\n} else {\n    std::cout << "zero";\n}\n```','["cpp","if","conditions"]',12,true),
  ('cpp-l1-c2-l2','cpp-l1-c2','cpp','for & while Loops',  'Loop structures',                          'theory','beginner',2,50,10,'# Loops\n\n```cpp\nfor (int i = 0; i < 5; i++)\n    std::cout << i << " ";\n\nint n = 0;\nwhile (n < 3) std::cout << n++ << " ";\n```','["cpp","loops","for","while"]',12,true),
  ('cpp-l1-c2-l3','cpp-l1-c2','cpp','switch Statement',   'Multi-branch switch',                       'theory','beginner',3,50,10,'# switch\n\n```cpp\nswitch (grade) {\n    case ''A'': std::cout << "Excellent"; break;\n    case ''B'': std::cout << "Good"; break;\n    default:   std::cout << "Keep going";\n}\n```','["cpp","switch","control"]',10,true),
  ('cpp-l1-c2-l4','cpp-l1-c2','cpp','Number Pyramid',     'Nested loops pattern challenge',            'coding','beginner',4,100,20,NULL,'["cpp","loops","pattern"]',15,true),
  ('cpp-l1-c3-l1','cpp-l1-c3','cpp','Functions',          'Define and call functions',                  'theory','beginner',1,50,10,'# Functions\n\n```cpp\nint add(int a, int b) { return a + b; }\nvoid greet(std::string name) {\n    std::cout << "Hi, " << name;\n}\n```','["cpp","functions"]',12,true),
  ('cpp-l1-c3-l2','cpp-l1-c3','cpp','Function Overloading','Multiple signatures, same name',           'theory','beginner',2,50,10,'# Overloading\n\n```cpp\ndouble area(double r) { return 3.14*r*r; }\ndouble area(double w, double h) { return w*h; }\n```','["cpp","overloading"]',12,true),
  ('cpp-l1-c3-l3','cpp-l1-c3','cpp','Arrays',             'Fixed-size arrays and iteration',            'theory','beginner',3,50,10,'# Arrays\n\n```cpp\nint nums[5] = {1, 2, 3, 4, 5};\nfor (int i = 0; i < 5; i++)\n    std::cout << nums[i] << " ";\n```','["cpp","arrays","basics"]',12,true),
  ('cpp-l1-c3-l4','cpp-l1-c3','cpp','Array Statistics',   'Find min, max, average of an array',        'coding','beginner',4,100,20,NULL,'["cpp","arrays","statistics"]',18,true),
  ('cpp-l2-c1-l1','cpp-l2-c1','cpp','Classes',            'Class definition, fields, methods',          'theory','intermediate',1,60,12,'# Classes\n\n```cpp\nclass Hero {\npublic:\n    std::string name;\n    int xp = 0;\n    Hero(std::string n) : name(n) {}\n    void gainXp(int v) { xp += v; }\n};\n```','["cpp","class","oop"]',18,true),
  ('cpp-l2-c1-l2','cpp-l2-c1','cpp','Constructors & Destructors','RAII and resource management',      'theory','intermediate',2,60,12,'# Constructor / Destructor\n\n```cpp\nclass Buffer {\n    int* data;\npublic:\n    Buffer(int size) { data = new int[size]; }\n    ~Buffer() { delete[] data; }   // RAII\n};\n```','["cpp","constructor","destructor","raii"]',18,true),
  ('cpp-l2-c1-l3','cpp-l2-c1','cpp','Inheritance',        'Base and derived classes',                  'theory','intermediate',3,60,12,'# Inheritance\n\n```cpp\nclass Animal { public: virtual void speak() {} };\nclass Dog : public Animal {\npublic:\n    void speak() override { std::cout << "Woof"; }\n};\n```','["cpp","inheritance","virtual"]',15,true),
  ('cpp-l2-c1-l4','cpp-l2-c1','cpp','Shape Hierarchy',    'Polymorphic area calculation',               'coding','intermediate',4,120,25,NULL,'["cpp","polymorphism","oop"]',25,true),
  ('cpp-l2-c2-l1','cpp-l2-c2','cpp','Pointers',           'Pointer variables and dereferencing',        'theory','intermediate',1,60,12,'# Pointers\n\n```cpp\nint x = 42;\nint* ptr = &x;           // address of x\nstd::cout << *ptr;      // 42 (dereference)\n*ptr = 100;\nstd::cout << x;         // 100\n```','["cpp","pointers","memory"]',20,true),
  ('cpp-l2-c2-l2','cpp-l2-c2','cpp','References',         'Alias for existing variables',               'theory','intermediate',2,60,12,'# References\n\n```cpp\nint a = 10;\nint& ref = a;   // ref is alias for a\nref = 20;\nstd::cout << a; // 20\n```','["cpp","references","aliases"]',15,true),
  ('cpp-l2-c2-l3','cpp-l2-c2','cpp','Dynamic Memory',     'new, delete and heap allocation',            'theory','intermediate',3,60,12,'# Dynamic Memory\n\n```cpp\nint* arr = new int[10];\narr[0] = 5;\ndelete[] arr;   // prevent leak\n```','["cpp","new","delete","heap"]',18,true),
  ('cpp-l2-c2-l4','cpp-l2-c2','cpp','Linked List',        'Build a singly linked list with pointers',   'coding','intermediate',4,120,25,NULL,'["cpp","linkedlist","pointers"]',28,true),
  ('cpp-l2-c3-l1','cpp-l2-c3','cpp','std::vector',        'Dynamic arrays with vector',                 'theory','intermediate',1,60,12,'# vector\n\n```cpp\n#include <vector>\nstd::vector<int> v = {1, 2, 3};\nv.push_back(4);\nfor (auto x : v) std::cout << x << " ";\n```','["cpp","vector","stl"]',15,true),
  ('cpp-l2-c3-l2','cpp-l2-c3','cpp','std::map & set',     'Ordered associative containers',             'theory','intermediate',2,60,12,'# map & set\n\n```cpp\n#include <map>\nstd::map<std::string,int> freq;\nfreq["hello"]++;\nfreq["world"]++;\nfor (auto& [k,v] : freq)\n    std::cout << k << ": " << v << "\n";\n```','["cpp","map","set","stl"]',15,true),
  ('cpp-l2-c3-l3','cpp-l2-c3','cpp','stack & queue',      'Adapter containers',                         'theory','intermediate',3,60,12,'# stack & queue\n\n```cpp\n#include <stack>\nstd::stack<int> s;\ns.push(1); s.push(2); s.push(3);\nstd::cout << s.top(); // 3\ns.pop();\n```','["cpp","stack","queue","stl"]',12,true),
  ('cpp-l2-c3-l4','cpp-l2-c3','cpp','Frequency Counter',  'Use map to count word frequencies',          'coding','intermediate',4,120,25,NULL,'["cpp","map","strings"]',22,true),
  ('cpp-l3-c1-l1','cpp-l3-c1','cpp','Function Templates', 'Write type-agnostic functions',              'theory','advanced',1,80,18,'# Function Templates\n\n```cpp\ntemplate<typename T>\nT maxVal(T a, T b) { return a > b ? a : b; }\n\nstd::cout << maxVal(3, 7);         // 7\nstd::cout << maxVal(3.14, 2.71);   // 3.14\n```','["cpp","template","generic"]',20,true),
  ('cpp-l3-c1-l2','cpp-l3-c1','cpp','Class Templates',    'Generic container classes',                  'theory','advanced',2,80,18,'# Class Templates\n\n```cpp\ntemplate<typename T>\nclass Stack {\n    std::vector<T> data;\npublic:\n    void push(T v) { data.push_back(v); }\n    T pop() { T v=data.back(); data.pop_back(); return v; }\n};\n```','["cpp","template","class"]',20,true),
  ('cpp-l3-c1-l3','cpp-l3-c1','cpp','Template Specialisation','Full and partial specialisation',        'theory','advanced',3,80,18,'# Specialisation\n\n```cpp\ntemplate<typename T>\nstruct TypeName { static const char* name; };\ntemplate<> struct TypeName<int> { static constexpr const char* name = "int"; };\n```','["cpp","specialization","template"]',18,true),
  ('cpp-l3-c1-l4','cpp-l3-c1','cpp','Generic Sort',       'Implement quicksort with templates',         'coding','advanced',4,200,40,NULL,'["cpp","template","sorting"]',30,true),
  ('cpp-l3-c2-l1','cpp-l3-c2','cpp','lvalue vs rvalue',   'Value categories and move semantics',        'theory','expert',1,80,18,'# rvalue References\n\n```cpp\nstd::string a = "Hello";\nstd::string b = std::move(a); // a is now empty\n// Avoids deep copy — O(1) transfer\n```','["cpp","move","rvalue"]',20,true),
  ('cpp-l3-c2-l2','cpp-l3-c2','cpp','smart pointers',     'unique_ptr, shared_ptr, weak_ptr',           'theory','expert',2,80,18,'# Smart Pointers\n\n```cpp\n#include <memory>\nauto sp = std::make_unique<Hero>("Alex");\nsp->gainXp(50);\n// auto-deleted when sp goes out of scope\n```','["cpp","unique_ptr","smart-pointer"]',20,true),
  ('cpp-l3-c2-l3','cpp-l3-c2','cpp','Rule of Five',       'Copy/move constructors and operators',       'theory','expert',3,80,18,'# Rule of Five\n\nWhen you define a destructor, also define:\n1. Copy constructor\n2. Copy assignment\n3. Move constructor\n4. Move assignment\n\nOr `= default` / `= delete` them explicitly.','["cpp","ruleoffive","memory"]',20,true),
  ('cpp-l3-c2-l4','cpp-l3-c2','cpp','Shared Buffer',      'Resource sharing with shared_ptr',           'coding','expert',4,200,40,NULL,'["cpp","shared_ptr","project"]',35,true),
  ('cpp-l3-c3-l1','cpp-l3-c3','cpp','std::thread',        'Spawn and join threads',                     'theory','expert',1,80,18,'# Threads\n\n```cpp\n#include <thread>\nvoid worker(int id) {\n    std::cout << "Thread " << id << "\n";\n}\nstd::thread t(worker, 1);\nt.join();\n```','["cpp","thread","concurrency"]',20,true),
  ('cpp-l3-c3-l2','cpp-l3-c3','cpp','Mutex & Locks',      'Protect shared data with mutex',             'theory','expert',2,80,18,'# Mutex\n\n```cpp\n#include <mutex>\nstd::mutex mtx;\nint counter = 0;\nvoid increment() {\n    std::lock_guard<std::mutex> lock(mtx);\n    counter++;\n}\n```','["cpp","mutex","synchronization"]',20,true),
  ('cpp-l3-c3-l3','cpp-l3-c3','cpp','std::future & async','Async tasks and futures',                   'theory','expert',3,80,18,'# future & async\n\n```cpp\n#include <future>\nauto f = std::async(std::launch::async, []() {\n    return 42;\n});\nstd::cout << f.get(); // 42\n```','["cpp","future","async"]',20,true),
  ('cpp-l3-c3-l4','cpp-l3-c3','cpp','Thread Pool',        'Build a basic thread pool',                  'coding','expert',4,250,50,NULL,'["cpp","threadpool","project"]',40,true);

-- =============================================================================
--  C
-- =============================================================================

INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES
  ('c-l1-c1','c','C Basics',           'Syntax, types and first program',              1,0,4,'🔧',true),
  ('c-l1-c2','c','Control Flow',       'if, for, while, switch',                       2,0,4,'🔀',true),
  ('c-l1-c3','c','Functions & Scope',  'Function definitions, prototypes, scope',       3,0,4,'⚙️',true),
  ('c-l2-c1','c','Pointers',           'Pointer basics, arithmetic, arrays',            4,1,4,'🧠',true),
  ('c-l2-c2','c','Strings & Arrays',   'char arrays, string.h functions',               5,1,4,'📝',true),
  ('c-l2-c3','c','Structs & Enums',    'Custom types and unions',                       6,1,4,'🏗️',true),
  ('c-l3-c1','c','Memory Management',  'malloc, calloc, realloc, free',                 7,2,4,'💾',true),
  ('c-l3-c2','c','File I/O',           'fopen, fread, fwrite, binary files',            8,2,4,'📂',true),
  ('c-l3-c3','c','Data Structures',    'Linked list, stack, queue in C',               9,2,4,'📊',true);

INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES
  ('c-l1-c1-l1','c-l1-c1','c','Hello C',           'Your first C program',                       'theory','beginner',1,50,10,'# Hello C\n\n```c\n#include <stdio.h>\nint main() {\n    printf("Hello, World!\n");\n    return 0;\n}\n```','["c","basics","printf"]',10,true),
  ('c-l1-c1-l2','c-l1-c1','c','Data Types',         'int, float, double, char',                   'theory','beginner',2,50,10,'# Types\n\n```c\nint age = 20;\nfloat gpa = 3.9f;\ndouble pi = 3.14159;\nchar grade = ''A'';\n```','["c","types","variables"]',12,true),
  ('c-l1-c1-l3','c-l1-c1','c','scanf & printf',     'Formatted I/O in C',                        'theory','beginner',3,50,10,'# I/O\n\n```c\nchar name[50];\nprintf("Name: ");\nscanf("%s", name);\nprintf("Hello, %s!\n", name);\n```','["c","scanf","printf","io"]',12,true),
  ('c-l1-c1-l4','c-l1-c1','c','Area Calculator',    'Calculate areas of shapes',                  'coding','beginner',4,100,20,NULL,'["c","basics","math"]',15,true),
  ('c-l1-c2-l1','c-l1-c2','c','if / else',           'Conditional statements',                     'theory','beginner',1,50,10,'# Conditions\n\n```c\nif (x > 0) printf("positive\n");\nelse if (x < 0) printf("negative\n");\nelse printf("zero\n");\n```','["c","if","conditionals"]',12,true),
  ('c-l1-c2-l2','c-l1-c2','c','for & while Loops',   'Iteration patterns',                        'theory','beginner',2,50,10,'# Loops\n\n```c\nfor (int i = 0; i < 5; i++) printf("%d ", i);\n\nint n = 0;\nwhile (n < 3) printf("%d ", n++);\n```','["c","loops","for","while"]',12,true),
  ('c-l1-c2-l3','c-l1-c2','c','switch',              'Multi-way branching',                        'theory','beginner',3,50,10,'# switch\n\n```c\nswitch (ch) {\n    case ''a'': case ''e'': case ''i'':\n    case ''o'': case ''u'':\n        printf("vowel\n"); break;\n    default:\n        printf("consonant\n");\n}\n```','["c","switch","control"]',10,true),
  ('c-l1-c2-l4','c-l1-c2','c','Multiplication Table','Print a times table',                       'coding','beginner',4,100,20,NULL,'["c","loops","table"]',15,true),
  ('c-l1-c3-l1','c-l1-c3','c','Functions',            'Define and call C functions',               'theory','beginner',1,50,10,'# Functions\n\n```c\nint add(int a, int b) { return a + b; }\nvoid greet(char* name) {\n    printf("Hello, %s!\n", name);\n}\n```','["c","functions"]',12,true),
  ('c-l1-c3-l2','c-l1-c3','c','Function Prototypes',  'Forward declarations',                     'theory','beginner',2,50,10,'# Prototypes\n\nDeclare function signatures before main so the compiler knows the types.\n\n```c\nint factorial(int n);  // prototype\n\nint main() { printf("%d\n", factorial(5)); }\n\nint factorial(int n) { return n<=1 ? 1 : n*factorial(n-1); }\n```','["c","prototype","declaration"]',12,true),
  ('c-l1-c3-l3','c-l1-c3','c','Variable Scope',       'Local, global and static scope',            'theory','beginner',3,50,10,'# Scope\n\n```c\nint global = 10;          // file scope\nvoid f() {\n    int local = 20;       // block scope\n    static int calls = 0; // persists between calls\n    calls++;\n}\n```','["c","scope","static"]',12,true),
  ('c-l1-c3-l4','c-l1-c3','c','Recursive Power',      'Implement x^n recursively',                'coding','beginner',4,100,20,NULL,'["c","recursion","power"]',15,true),
  ('c-l2-c1-l1','c-l2-c1','c','Pointer Basics',       'Address-of, dereference operators',         'theory','intermediate',1,60,12,'# Pointers\n\n```c\nint x = 42;\nint *ptr = &x;     // address\nprintf("%d\n", *ptr); // 42\n*ptr = 100;\nprintf("%d\n", x);    // 100\n```','["c","pointers","address"]',20,true),
  ('c-l2-c1-l2','c-l2-c1','c','Pointer Arithmetic',   'Traverse arrays with pointers',             'theory','intermediate',2,60,12,'# Pointer Arithmetic\n\n```c\nint arr[] = {10, 20, 30};\nint *p = arr;\nfor (int i = 0; i < 3; i++)\n    printf("%d ", *(p + i));\n```','["c","pointer-arithmetic","arrays"]',18,true),
  ('c-l2-c1-l3','c-l2-c1','c','Pointers & Functions', 'Pass by pointer, return pointer',           'theory','intermediate',3,60,12,'# Pass by Pointer\n\n```c\nvoid swap(int *a, int *b) {\n    int tmp = *a;\n    *a = *b;\n    *b = tmp;\n}\nint x=1, y=2;\nswap(&x, &y); // x=2, y=1\n```','["c","swap","pointer"]',15,true),
  ('c-l2-c1-l4','c-l2-c1','c','Reverse Array',        'Reverse in-place using pointers',           'coding','intermediate',4,120,25,NULL,'["c","pointers","array"]',20,true),
  ('c-l2-c2-l1','c-l2-c2','c','Character Arrays',     'C strings and null terminator',              'theory','intermediate',1,60,12,'# C Strings\n\n```c\nchar name[] = "Alex";     // null-terminated\nchar buf[50];\nsprintf(buf, "Hi %s", name);\nprintf("%s\n", buf);\n```','["c","strings","char"]',15,true),
  ('c-l2-c2-l2','c-l2-c2','c','string.h Functions',   'strlen, strcpy, strcat, strcmp',            'theory','intermediate',2,60,12,'# string.h\n\n```c\n#include <string.h>\nchar s1[50] = "Hello";\nchar s2[] = " World";\nstrcat(s1, s2);  // "Hello World"\nprintf("%zu\n", strlen(s1)); // 11\n```','["c","string.h","manipulation"]',15,true),
  ('c-l2-c2-l3','c-l2-c2','c','2D Arrays',            'Matrix representation and access',           'theory','intermediate',3,60,12,'# 2D Arrays\n\n```c\nint matrix[3][3] = {{1,2,3},{4,5,6},{7,8,9}};\nfor (int i=0;i<3;i++) {\n    for (int j=0;j<3;j++)\n        printf("%d ", matrix[i][j]);\n    printf("\n");\n}\n```','["c","2darray","matrix"]',15,true),
  ('c-l2-c2-l4','c-l2-c2','c','String Palindrome',    'Check if a string is a palindrome',         'coding','intermediate',4,120,25,NULL,'["c","strings","palindrome"]',20,true),
  ('c-l2-c3-l1','c-l2-c3','c','Structs',              'Define custom data structures',              'theory','intermediate',1,60,12,'# Structs\n\n```c\nstruct Hero {\n    char name[50];\n    int xp;\n    int level;\n};\nstruct Hero h = {"Alex", 500, 3};\nprintf("%s Lv%d\n", h.name, h.level);\n```','["c","struct","custom-type"]',18,true),
  ('c-l2-c3-l2','c-l2-c3','c','Struct Pointers',      'Arrow operator and dynamic structs',         'theory','intermediate',2,60,12,'# Struct Pointers\n\n```c\nstruct Hero *p = &h;\nprintf("%s\n", p->name);  // arrow operator\np->xp += 100;\n```','["c","struct-pointer","arrow"]',15,true),
  ('c-l2-c3-l3','c-l2-c3','c','Enums & Unions',       'Named constants and shared memory',          'theory','intermediate',3,60,12,'# Enums & Unions\n\n```c\nenum Direction { NORTH, SOUTH, EAST, WEST };\nunion Data { int i; float f; char c; };\nunion Data d; d.i = 42;\n```','["c","enum","union"]',12,true),
  ('c-l2-c3-l4','c-l2-c3','c','Student Records',      'Array of structs with sorting',              'coding','intermediate',4,120,25,NULL,'["c","struct","sorting"]',25,true),
  ('c-l3-c1-l1','c-l3-c1','c','malloc & free',        'Heap allocation and memory leaks',           'theory','advanced',1,80,18,'# malloc / free\n\n```c\n#include <stdlib.h>\nint *arr = (int*)malloc(10 * sizeof(int));\nif (!arr) { perror("malloc"); exit(1); }\narr[0] = 42;\nfree(arr);  // mandatory!\n```','["c","malloc","heap"]',20,true),
  ('c-l3-c1-l2','c-l3-c1','c','calloc & realloc',     'Zero-initialised and resizable memory',      'theory','advanced',2,80,18,'# calloc / realloc\n\n```c\nint *arr = (int*)calloc(5, sizeof(int)); // zeroed\narr = (int*)realloc(arr, 10 * sizeof(int)); // grow\nfree(arr);\n```','["c","calloc","realloc"]',18,true),
  ('c-l3-c1-l3','c-l3-c1','c','Memory Debugging',     'Common bugs: leaks, dangling ptrs, overflow', 'theory','advanced',3,80,18,'# Memory Bugs\n\n- **Leak**: malloc without free\n- **Dangling pointer**: using ptr after free\n- **Buffer overflow**: writing past array bounds\n- **Double free**: free()-ing same block twice\n\nUse **Valgrind** to detect these at runtime.','["c","valgrind","memory-safety"]',18,true),
  ('c-l3-c1-l4','c-l3-c1','c','Dynamic Matrix',       'Allocate 2D array on heap',                  'coding','advanced',4,200,40,NULL,'["c","malloc","matrix"]',30,true),
  ('c-l3-c2-l1','c-l3-c2','c','fopen & fclose',       'Open, close and modes',                      'theory','advanced',1,80,18,'# File Open/Close\n\n```c\nFILE *fp = fopen("data.txt", "r");\nif (!fp) { perror("fopen"); exit(1); }\n// ... read/write ...\nfclose(fp);\n```','["c","fopen","file"]',15,true),
  ('c-l3-c2-l2','c-l3-c2','c','fprintf & fscanf',     'Formatted file I/O',                         'theory','advanced',2,80,18,'# fprintf / fscanf\n\n```c\nFILE *fp = fopen("log.txt","w");\nfprintf(fp, "User: %s XP: %d\n", name, xp);\nfclose(fp);\n```','["c","fprintf","fscanf"]',15,true),
  ('c-l3-c2-l3','c-l3-c2','c','Binary Files',         'fread, fwrite for binary data',              'theory','advanced',3,80,18,'# Binary I/O\n\n```c\nstruct Hero h = {"Alex", 500, 3};\nFILE *fp = fopen("heroes.bin","wb");\nfwrite(&h, sizeof(struct Hero), 1, fp);\nfclose(fp);\n```','["c","binary","fread","fwrite"]',18,true),
  ('c-l3-c2-l4','c-l3-c2','c','High Score System',    'Save and load scores in binary',             'coding','advanced',4,200,40,NULL,'["c","binary","file","project"]',30,true),
  ('c-l3-c3-l1','c-l3-c3','c','Linked List in C',     'Nodes, insertion and traversal',              'theory','expert',1,80,18,'# Linked List\n\n```c\nstruct Node { int data; struct Node *next; };\n\nvoid prepend(struct Node **head, int val) {\n    struct Node *n = malloc(sizeof(struct Node));\n    n->data = val; n->next = *head;\n    *head = n;\n}\n```','["c","linkedlist","struct"]',25,true),
  ('c-l3-c3-l2','c-l3-c3','c','Stack with Arrays',    'Push / pop with a fixed-size array',          'theory','expert',2,80,18,'# Stack\n\n```c\n#define MAX 100\nint stack[MAX], top = -1;\nvoid push(int v) { stack[++top] = v; }\nint pop() { return stack[top--]; }\n```','["c","stack","arrays"]',20,true),
  ('c-l3-c3-l3','c-l3-c3','c','Queue with Linked List','Enqueue / dequeue with dynamic nodes',      'theory','expert',3,80,18,'# Queue\n\nMaintain head and tail pointers for O(1) enqueue and dequeue.\n\n```c\nstruct Queue { struct Node *head, *tail; };\nvoid enqueue(struct Queue *q, int val) { ... }\nint  dequeue(struct Queue *q) { ... }\n```','["c","queue","linkedlist"]',20,true),
  ('c-l3-c3-l4','c-l3-c3','c','Expression Evaluator', 'Evaluate postfix expressions with a stack',   'coding','expert',4,250,50,NULL,'["c","stack","expression","project"]',40,true);

-- =============================================================================
-- QUIZ QUESTIONS (sample for Python Level 1)
-- =============================================================================

INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, code_snippet)
VALUES
  ('q-py-l1-c1-l3-1','py-l1-c1-l3',
   'Which of the following is an integer in Python?',
   '["3.14","\"42\"","42","True"]',
   2,
   '42 is an integer literal. 3.14 is a float, "42" is a string, and True is a bool.',
   NULL),
  ('q-py-l1-c1-l3-2','py-l1-c1-l3',
   'What type does Python assign to x = 3.0?',
   '["int","float","str","complex"]',
   1,
   'A number with a decimal point is inferred as float.',
   'x = 3.0\nprint(type(x))  # <class ''float''>'),
  ('q-py-l1-c1-l3-3','py-l1-c1-l3',
   'Which keyword makes a variable constant in Python?',
   '["const","final","val","None of the above"]',
   3,
   'Python has no built-in constant keyword; the convention is UPPER_CASE naming.',
   NULL),
  ('q-py-l1-c1-l3-4','py-l1-c1-l3',
   'What is the result of type(True)?',
   '["int","bool","str","NoneType"]',
   1,
   'bool is a subclass of int in Python, but type(True) returns <class bool>.',
   NULL);

-- JavaScript Level 1 Chapter 1 quiz
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, code_snippet)
VALUES
  ('q-js-l1-c1-l3-1','js-l1-c1-l3',
   'Which keyword declares a block-scoped, reassignable variable?',
   '["var","let","const","function"]',
   1,
   'let is block-scoped and can be reassigned. const is block-scoped but immutable. var is function-scoped.',
   NULL),
  ('q-js-l1-c1-l3-2','js-l1-c1-l3',
   'What does typeof "42" return?',
   '["number","string","undefined","object"]',
   1,
   '"42" is wrapped in quotes so it is a string literal.',
   'console.log(typeof "42"); // "string"'),
  ('q-js-l1-c1-l3-3','js-l1-c1-l3',
   'Which value is falsy in JavaScript?',
   '["1","\"false\"","[]","0"]',
   3,
   '0, "", null, undefined, NaN, and false are the six falsy values.',
   NULL),
  ('q-js-l1-c1-l3-4','js-l1-c1-l3',
   'What is the result of 3 + "3" in JavaScript?',
   '["6","\"33\"","NaN","33"]',
   1,
   'When + is used with a string, JS coerces the number to string and concatenates.',
   'console.log(3 + "3"); // "33"');

-- Java Level 1 Chapter 1 quiz
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, code_snippet)
VALUES
  ('q-java-l1-c1-l3-1','java-l1-c1-l3',
   'What is the size of an int in Java?',
   '["2 bytes","4 bytes","8 bytes","Platform dependent"]',
   1,
   'Java int is always 32-bit (4 bytes) regardless of platform.',
   NULL),
  ('q-java-l1-c1-l3-2','java-l1-c1-l3',
   'Which of these is NOT a primitive type in Java?',
   '["int","String","boolean","char"]',
   1,
   'String is a reference (object) type in Java, not a primitive.',
   NULL),
  ('q-java-l1-c1-l3-3','java-l1-c1-l3',
   'What does == compare for objects in Java?',
   '["Value equality","Reference equality","Hash codes","Content equality"]',
   1,
   '== checks if two references point to the same object. Use .equals() for value comparison.',
   'String a = new String("hi");\nString b = new String("hi");\nSystem.out.println(a == b);       // false\nSystem.out.println(a.equals(b));  // true'),
  ('q-java-l1-c1-l3-4','java-l1-c1-l3',
   'Which wrapper class corresponds to int?',
   '["Int","Integer","IntWrapper","Number"]',
   1,
   'Java provides Integer as the boxed (object) version of the int primitive.',
   NULL);
