-- =============================================================================
-- CodeQuest - Master Lesson Data Seed (All Missing Lessons & Content)
-- Run this in Supabase SQL Editor to populate all missing lessons,
-- quiz questions, coding challenges, and boss battle data.
-- =============================================================================

-- 1. Helper function for stable deterministic UUIDs
CREATE OR REPLACE FUNCTION cq_id(t TEXT) RETURNS UUID
LANGUAGE SQL IMMUTABLE AS $$
  SELECT (
    substring(md5(t),  1, 8) || '-' ||
    substring(md5(t),  9, 4) || '-' ||
    substring(md5(t), 13, 4) || '-' ||
    substring(md5(t), 17, 4) || '-' ||
    substring(md5(t), 21, 12)
  )::uuid;
$$;

-- =============================================================================
-- A. QUIZ QUESTIONS FOR EXISTING QUIZ LESSONS MISSING QUESTIONS
-- =============================================================================
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, code_snippet, order_index)
VALUES (cq_id('q-py-var-quiz-1'), 'dab88098-0d8d-46ca-9931-56e177453c9f', 'What will `type(42.0)` output in Python?', '["<class ''int''>", "<class ''float''>", "<class ''double''>", "<class ''num''>"]'::jsonb, 1, 'Numbers with decimal points are instances of the float class in Python.', 'x = 42.0
print(type(x))', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, code_snippet, order_index)
VALUES (cq_id('q-py-var-quiz-2'), 'dab88098-0d8d-46ca-9931-56e177453c9f', 'Which variable assignment will raise a SyntaxError?', '["_total = 100", "user_2 = ''Alex''", "2nd_place = ''Sam''", "user_score = 50"]'::jsonb, 2, 'Variable names cannot start with a digit in Python.', NULL, 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, code_snippet, order_index)
VALUES (cq_id('q-py-var-quiz-3'), 'dab88098-0d8d-46ca-9931-56e177453c9f', 'What does `bool('''')` evaluate to in Python?', '["True", "False", "None", "Error"]'::jsonb, 1, 'An empty string is a falsy value in Python, so bool('''') evaluates to False.', 'empty = ''''
print(bool(empty))', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, code_snippet, order_index)
VALUES (cq_id('q-py-var-quiz-4'), 'dab88098-0d8d-46ca-9931-56e177453c9f', 'What is the result of `str(10) + str(20)` in Python?', '["30", "''1020''", "Error", "''10 20''"]'::jsonb, 1, 'Converting to string and using + performs string concatenation: ''10'' + ''20'' = ''1020''.', 'print(str(10) + str(20))', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, code_snippet, order_index)
VALUES (cq_id('q-py-rev-1'), 'e81c5b8b-92a6-48f4-89de-1ae231885f2e', 'Which symbol is used for single-line comments in Python?', '["//", "#", "/*", "--"]'::jsonb, 1, '# is the Python symbol for single-line comments.', NULL, 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, code_snippet, order_index)
VALUES (cq_id('q-py-rev-2'), 'e81c5b8b-92a6-48f4-89de-1ae231885f2e', 'What does the print() function do by default at the end of its output?', '["Prints a tab", "Appends a newline", "Flushes the buffer only", "Nothing"]'::jsonb, 1, 'By default, print() has end=''\n'', which moves to the next line.', 'print(''Line 1'')
print(''Line 2'')', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, code_snippet, order_index)
VALUES (cq_id('q-py-rev-3'), 'e81c5b8b-92a6-48f4-89de-1ae231885f2e', 'Which function is used to get the number of characters in a string?', '["length()", "size()", "len()", "count()"]'::jsonb, 2, 'len() returns the length of a string, list, tuple, or dictionary.', 's = ''CodeQuest''
print(len(s)) # 9', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, code_snippet, order_index)
VALUES (cq_id('q-py-rev-4'), 'e81c5b8b-92a6-48f4-89de-1ae231885f2e', 'What is the result of 15 // 4 in Python?', '["3.75", "3", "4", "3.0"]'::jsonb, 1, '// performs floor division in Python, discarding the fractional part.', 'print(15 // 4) # 3', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, code_snippet, order_index)
VALUES (cq_id('q-py-syn-1'), 'f0855236-02ae-45bb-ac30-58c108a33a49', 'How are code blocks defined in Python?', '["Curly braces {}", "Indentation (whitespace)", "Begin...End keywords", "Square brackets []"]'::jsonb, 1, 'Python uses indentation (standard 4 spaces) to define code blocks.', NULL, 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, code_snippet, order_index)
VALUES (cq_id('q-py-syn-2'), 'f0855236-02ae-45bb-ac30-58c108a33a49', 'Which keyword is used to import a library in Python?', '["include", "import", "using", "require"]'::jsonb, 1, 'import is the Python keyword to bring in modules and packages.', 'import math
print(math.sqrt(16))', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, code_snippet, order_index)
VALUES (cq_id('q-py-syn-3'), 'f0855236-02ae-45bb-ac30-58c108a33a49', 'What will `3 * ''A''` output in Python?', '["Error", "''AAA''", "3A", "NaN"]'::jsonb, 1, 'Multiplying a string by an integer repeats the string that many times.', 'print(3 * ''A'') # AAA', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, code_snippet, order_index)
VALUES (cq_id('q-py-syn-4'), 'f0855236-02ae-45bb-ac30-58c108a33a49', 'Which statement correctly converts ''123'' into an integer?', '["int(''123'')", "to_int(''123'')", "(int)''123''", "Integer.parseInt(''123'')"]'::jsonb, 0, 'int(''123'') parses the string literal and returns the integer 123.', NULL, 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;

-- =============================================================================
-- B. CODING CHALLENGES FOR EXISTING LESSONS MISSING CHALLENGES
-- =============================================================================
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-py-var-1'), '1cbd913f-a26a-4335-baf6-d3470381c5d8', 'python', 'Variable Swap & Math',
'Declare two variables `player_name` with value "Hero" and `score` with value 100. Then print both on separate lines.',
'# Create your variables below
player_name = ""
score = 0

# Print them
print(player_name)
print(score)',
'player_name = "Hero"
score = 100
print(player_name)
print(score)',
'["Assign string Hero to player_name", "Assign integer 100 to score", "Use print() for each variable"]'::jsonb,
'beginner', 80, 20, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, starter_code=EXCLUDED.starter_code, solution_code=EXCLUDED.solution_code;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-py-welcome-1'), 'd2052bb6-79a9-4b93-9458-a9f51d2a60da', 'python', 'Welcome Screen Banner',
'Print a welcome banner with three lines:
Line 1: ====================
Line 2: WELCOME TO CODEQUEST
Line 3: ====================',
'# Print your banner here
',
'print("====================")
print("WELCOME TO CODEQUEST")
print("====================")',
'["Use three separate print() calls", "Line 1 has 20 equal signs", "Line 2 text must match WELCOME TO CODEQUEST exactly"]'::jsonb,
'beginner', 80, 20, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, starter_code=EXCLUDED.starter_code, solution_code=EXCLUDED.solution_code;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-py-profile-1'), '6a58f87e-8c38-49df-89b3-c8248b022c83', 'python', 'Student Profile Card',
'Create variables name = "Alex", grade = 10, gpa = 3.9. Print an formatted profile:
Name: Alex | Grade: 10 | GPA: 3.9',
'# Define your variables
name = "Alex"
grade = 10
gpa = 3.9

# Print formatted profile
',
'name = "Alex"
grade = 10
gpa = 3.9
print(f"Name: {name} | Grade: {grade} | GPA: {gpa}")',
'["Use an f-string: f\"Name: {name} | Grade: {grade} | GPA: {gpa}\"", "Ensure the separators match exactly"]'::jsonb,
'beginner', 90, 25, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, starter_code=EXCLUDED.starter_code, solution_code=EXCLUDED.solution_code;

-- =============================================================================
-- C. BOSS BATTLE QUIZ QUESTIONS (ALL 20 BOSSES)
-- =============================================================================
-- Boss: Python Basics Boss (10000001-0000-0000-0000-000000000005)
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-10000001-0000-0000-0000-000000000005-1'), '10000001-0000-0000-0000-000000000005', 'The Data Type Dragon asks: What happens when you execute `float(''3.1415'')`?', '["Returns integer 3", "Returns float 3.1415", "Throws ValueError", "Returns string"]'::jsonb, 1, 'float() successfully converts numeric strings with decimal points into floating-point numbers.', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-10000001-0000-0000-0000-000000000005-2'), '10000001-0000-0000-0000-000000000005', 'The Dragon roars: Which variable name is INVALID?', '["_secret", "data_2026", "2_fast", "userScore"]'::jsonb, 2, 'Identifiers in Python cannot begin with a number.', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-10000001-0000-0000-0000-000000000005-3'), '10000001-0000-0000-0000-000000000005', 'The Dragon strikes: What is the output of `type(False)`?', '["<class ''bool''>", "<class ''int''>", "<class ''boolean''>", "<class ''str''>"]'::jsonb, 0, 'bool is the boolean type in Python representing True or False.', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-10000001-0000-0000-0000-000000000005-4'), '10000001-0000-0000-0000-000000000005', 'FINAL ATTACK: What does `x = 5, x += 3 * 2` evaluate to for x?', '["16", "11", "13", "10"]'::jsonb, 1, 'Multiplication has higher precedence than addition: 3 * 2 = 6, then 5 + 6 = 11.', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;

-- Boss: Loop Boss Battle (10000001-0000-0000-0000-000000000010)
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-10000001-0000-0000-0000-000000000010-1'), '10000001-0000-0000-0000-000000000010', 'The Loop Lord attacks! How many times will `for i in range(1, 10, 2):` execute?', '["4 times", "5 times", "9 times", "10 times"]'::jsonb, 1, 'It produces 1, 3, 5, 7, 9 - exactly 5 values.', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-10000001-0000-0000-0000-000000000010-2'), '10000001-0000-0000-0000-000000000010', 'The Loop Lord casts an infinite loop! Which keyword breaks out of a loop immediately?', '["continue", "pass", "break", "return"]'::jsonb, 2, 'break immediately terminates the innermost enclosing loop.', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-10000001-0000-0000-0000-000000000010-3'), '10000001-0000-0000-0000-000000000010', 'What is the output of `[x for x in range(6) if x % 2 == 0]`?', '["[1, 3, 5]", "[0, 2, 4]", "[2, 4, 6]", "[0, 1, 2, 3, 4, 5]"]'::jsonb, 1, 'Even numbers below 6 are 0, 2, and 4.', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-10000001-0000-0000-0000-000000000010-4'), '10000001-0000-0000-0000-000000000010', 'FINAL BLOW: What does `while False:` execute in Python?', '["Runs once", "Runs infinitely", "Never runs the loop body", "Throws error"]'::jsonb, 2, 'Because the condition is False from the start, the loop body never runs.', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;

-- Boss: Function Master Boss (10000001-0000-0000-0000-000000000015)
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-10000001-0000-0000-0000-000000000015-1'), '10000001-0000-0000-0000-000000000015', 'The Function Master challenges you: What does a Python function return if there is no return statement?', '["0", "False", "None", "undefined"]'::jsonb, 2, 'Functions without an explicit return statement return None by default.', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-10000001-0000-0000-0000-000000000015-2'), '10000001-0000-0000-0000-000000000015', 'What does `*args` inside a function parameter list collect?', '["Keyword arguments as a dict", "Positional arguments as a tuple", "A list of strings", "All global variables"]'::jsonb, 1, '*args packs extra positional arguments into a tuple.', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-10000001-0000-0000-0000-000000000015-3'), '10000001-0000-0000-0000-000000000015', 'What is the output of `(lambda a, b: a * b + 2)(3, 4)`?', '["14", "18", "24", "12"]'::jsonb, 0, '3 * 4 = 12, then + 2 = 14.', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-10000001-0000-0000-0000-000000000015-4'), '10000001-0000-0000-0000-000000000015', 'FINAL COMBO: Can a function modify a global integer without the `global` keyword?', '["Yes, integers are mutable", "No, an UnboundLocalError occurs upon assignment", "Yes, with self", "Only in Python 2"]'::jsonb, 1, 'Assigning to a variable inside a function marks it as local, unless declared global.', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;

-- Boss: Boss Battle: Registration System (829f35a9-7716-4274-b5e3-80bcc351344c)
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-829f35a9-7716-4274-b5e3-80bcc351344c-1'), '829f35a9-7716-4274-b5e3-80bcc351344c', 'System Boss asks: Which data structure is ideal for checking if a username is already taken in O(1) time?', '["List", "Set", "Tuple", "Linked List"]'::jsonb, 1, 'Sets provide average O(1) time complexity for membership lookups using hashing.', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-829f35a9-7716-4274-b5e3-80bcc351344c-2'), '829f35a9-7716-4274-b5e3-80bcc351344c', 'How do you safely extract an optional key ''phone'' from dictionary `user` without KeyError?', '["user[''phone'']", "user.get(''phone'', None)", "user.pop(''phone'')", "user.find(''phone'')"]'::jsonb, 1, 'dict.get(key, default) returns default if the key is missing without raising KeyError.', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-829f35a9-7716-4274-b5e3-80bcc351344c-3'), '829f35a9-7716-4274-b5e3-80bcc351344c', 'How do you validate that an email string contains both ''@'' and ''.''?', '["''@'' in email and ''.'' in email", "email.has(''@'') and email.has(''.'')", "email.contains(''@'', ''.'')", "email[''@''] and email[''.'']"]'::jsonb, 0, 'The ''in'' operator checks substring existence in Python cleanly.', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-829f35a9-7716-4274-b5e3-80bcc351344c-4'), '829f35a9-7716-4274-b5e3-80bcc351344c', 'FINAL DEFENSE: What error is raised when `int(''invalid_age'')` is called?', '["TypeError", "KeyError", "ValueError", "AttributeError"]'::jsonb, 2, 'int() raises ValueError when the string contains non-digit characters.', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;

-- Boss: Variables Boss Battle (a4975548-8675-4a1e-83c4-144533972c22)
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-a4975548-8675-4a1e-83c4-144533972c22-1'), 'a4975548-8675-4a1e-83c4-144533972c22', 'The Variable Specter asks: Which statement swaps variables `a` and `b` in Python without a temp variable?', '["swap(a, b)", "a, b = b, a", "a = b, b = a", "a.swap(b)"]'::jsonb, 1, 'Tuple packing and unpacking allows `a, b = b, a` in a single atomic expression.', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-a4975548-8675-4a1e-83c4-144533972c22-2'), 'a4975548-8675-4a1e-83c4-144533972c22', 'What is the data type of `(42,)`?', '["int", "list", "tuple", "set"]'::jsonb, 2, 'A trailing comma inside parentheses creates a single-element tuple.', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-a4975548-8675-4a1e-83c4-144533972c22-3'), 'a4975548-8675-4a1e-83c4-144533972c22', 'What does `x is y` check in Python?', '["Value equality", "Object identity (same memory address)", "Alphabetical order", "Type equality"]'::jsonb, 1, 'The ''is'' operator checks if both variables refer to the exact same object in memory.', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-a4975548-8675-4a1e-83c4-144533972c22-4'), 'a4975548-8675-4a1e-83c4-144533972c22', 'FINAL SHIELD: Are strings mutable in Python?', '["Yes, via index assignment", "No, strings are immutable", "Only raw strings are mutable", "Yes, using append()"]'::jsonb, 1, 'Strings in Python cannot be modified in-place, all string methods return new strings.', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;

-- Boss: JS Fundamentals Boss (20000001-0000-0000-0000-000000000005)
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-20000001-0000-0000-0000-000000000005-1'), '20000001-0000-0000-0000-000000000005', 'The JavaScript Titan challenges: What does `typeof NaN` return in JS?', '["''nan''", "''undefined''", "''number''", "''object''"]'::jsonb, 2, 'In JavaScript, NaN stands for ''Not a Number'', but its typeof is ''number''.', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-20000001-0000-0000-0000-000000000005-2'), '20000001-0000-0000-0000-000000000005', 'What is the difference between `==` and `===`?', '["== checks types, === does not", "=== checks both value and type without coercion", "They are identical in ES6", "=== is for objects only"]'::jsonb, 1, '=== performs strict equality without implicit type coercion.', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-20000001-0000-0000-0000-000000000005-3'), '20000001-0000-0000-0000-000000000005', 'What does `Boolean([])` return in JavaScript?', '["false", "true", "undefined", "TypeError"]'::jsonb, 1, 'All objects (including arrays and empty arrays) are truthy in JavaScript.', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-20000001-0000-0000-0000-000000000005-4'), '20000001-0000-0000-0000-000000000005', 'FINAL ATTACK: What will `console.log(1 + ''2'' + 3)` print?', '["''6''", "''123''", "''33''", "NaN"]'::jsonb, 1, '1 + ''2'' concatenates to ''12'', then ''12'' + 3 concatenates to ''123''.', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;

-- Boss: DOM Master Boss (20000001-0000-0000-0000-000000000010)
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-20000001-0000-0000-0000-000000000010-1'), '20000001-0000-0000-0000-000000000010', 'The DOM Master attacks: Which method attaches an event listener without overwriting existing ones?', '["element.onclick = fn", "element.addEventListener()", "element.attach()", "element.listen()"]'::jsonb, 1, 'addEventListener allows multiple independent listeners on the same event.', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-20000001-0000-0000-0000-000000000010-2'), '20000001-0000-0000-0000-000000000010', 'What does `event.preventDefault()` do?', '["Stops event bubbling", "Prevents default browser action (e.g. form submit)", "Removes the element", "Disables JavaScript"]'::jsonb, 1, 'It prevents the browser''s default behavior such as following a link or submitting a form.', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-20000001-0000-0000-0000-000000000010-3'), '20000001-0000-0000-0000-000000000010', 'Which selector selects an element with id ''hero''?', '["document.querySelector(''.hero'')", "document.querySelector(''#hero'')", "document.querySelector(''$hero'')", "document.querySelector(''@hero'')"]'::jsonb, 1, '# denotes an ID selector in CSS and querySelector.', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-20000001-0000-0000-0000-000000000010-4'), '20000001-0000-0000-0000-000000000010', 'FINAL STRIKE: What is event delegation in JavaScript?', '["Adding listeners to every child node", "Handling events on a parent using event bubbling", "Stopping all events", "Using Web Workers"]'::jsonb, 1, 'Event delegation leverages bubbling by placing a single listener on a parent element.', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;

-- Boss: Async Ninja Boss (20000001-0000-0000-0000-000000000015)
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-20000001-0000-0000-0000-000000000015-1'), '20000001-0000-0000-0000-000000000015', 'The Async Ninja asks: What are the three states of a JavaScript Promise?', '["pending, fulfilled, rejected", "waiting, running, done", "open, resolved, closed", "start, working, finish"]'::jsonb, 0, 'A promise can be pending, fulfilled (resolved), or rejected.', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-20000001-0000-0000-0000-000000000015-2'), '20000001-0000-0000-0000-000000000015', 'What does the `await` keyword do?', '["Blocks the entire OS thread", "Pauses async function execution until Promise resolves", "Creates a web worker", "Retries failed requests"]'::jsonb, 1, 'await pauses the execution inside an async function non-blockingly until the Promise settles.', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-20000001-0000-0000-0000-000000000015-3'), '20000001-0000-0000-0000-000000000015', 'What will `Promise.all([p1, p2])` do if `p1` rejects?', '["Ignores p1 and returns p2", "Immediately rejects with p1''s error", "Retries p1", "Returns [null, p2]"]'::jsonb, 1, 'Promise.all short-circuits and rejects immediately if any input promise rejects.', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-20000001-0000-0000-0000-000000000015-4'), '20000001-0000-0000-0000-000000000015', 'FINAL SHURIKEN: What order will this run: setTimeout 0ms vs Promise.resolve().then()?', '["setTimeout runs first", "Promise microtask runs first", "Random order", "Simultaneously"]'::jsonb, 1, 'Microtasks (Promises) are processed before macrotasks (setTimeout) in the event loop.', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;

-- Boss: Dart Basics Boss (30000001-0000-0000-0000-000000000005)
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-30000001-0000-0000-0000-000000000005-1'), '30000001-0000-0000-0000-000000000005', 'The Null Pointer Boss attacks! What does `String? name,` signify in Dart?', '["name can never be null", "name can hold a String or null", "name is a pointer", "name is a constant"]'::jsonb, 1, 'The question mark indicates a nullable type in Dart sound null safety.', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-30000001-0000-0000-0000-000000000005-2'), '30000001-0000-0000-0000-000000000005', 'What does the null-coalescing operator `??` do?', '["Throws an exception if null", "Returns left operand if non-null, else right operand", "Forces non-null cast", "Checks equality with null"]'::jsonb, 1, 'expr1 ?? expr2 evaluates to expr1 if not null, otherwise expr2.', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-30000001-0000-0000-0000-000000000005-3'), '30000001-0000-0000-0000-000000000005', 'What is the difference between `final` and `const` in Dart?', '["final is compile-time, const is runtime", "const is compile-time constant, final is runtime single-assignment", "They are identical", "const can be reassigned"]'::jsonb, 1, 'const values are frozen at compile time, while final variables are assigned once at runtime.', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-30000001-0000-0000-0000-000000000005-4'), '30000001-0000-0000-0000-000000000005', 'FINAL SPELL: What operator is used for safe navigation when calling a method on a nullable object?', '["name!.length", "name?.length", "name??.length", "name->length"]'::jsonb, 1, '?. safely calls the method or getter only if the target is not null.', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;

-- Boss: Dart OOP Boss (30000001-0000-0000-0000-000000000010)
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-30000001-0000-0000-0000-000000000010-1'), '30000001-0000-0000-0000-000000000010', 'The OOP Titan asks: Which keyword allows code reuse without multiple inheritance in Dart?', '["implements", "extends", "with (mixin)", "abstract"]'::jsonb, 2, 'Mixins (applied via ''with'') provide a way to reuse a class''s code in multiple hierarchies.', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-30000001-0000-0000-0000-000000000010-2'), '30000001-0000-0000-0000-000000000010', 'What is a factory constructor in Dart used for?', '["Creating compile-time constants", "Returning an existing cached instance or subtype", "Allocating hardware memory", "Deleting objects"]'::jsonb, 1, 'Factory constructors don''t always create new instances, they can return cached instances or subtypes.', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-30000001-0000-0000-0000-000000000010-3'), '30000001-0000-0000-0000-000000000010', 'What keyword makes a class implement an interface in Dart?', '["interface", "implements", "inherits", "conforms"]'::jsonb, 1, 'In Dart, every class implicitly defines an interface, implemented via the ''implements'' keyword.', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-30000001-0000-0000-0000-000000000010-4'), '30000001-0000-0000-0000-000000000010', 'FINAL SMASH: What does the cascade operator `..` do in Dart?', '["Null check", "Performs a sequence of operations on the same object", "Deep copies an object", "Bitwise shift"]'::jsonb, 1, 'Cascades (..) allow you to perform a sequence of operations on the same object.', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;

-- Boss: Stream Boss (30000001-0000-0000-0000-000000000015)
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-30000001-0000-0000-0000-000000000015-1'), '30000001-0000-0000-0000-000000000015', 'The Stream Sovereign asks: What is the difference between a Future and a Stream in Dart?', '["Future delivers multiple values, Stream delivers one", "Future delivers a single asynchronous result, Stream delivers multiple events over time", "They are identical", "Stream is synchronous"]'::jsonb, 1, 'A Future represents a single future value, a Stream represents an asynchronous sequence of data.', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-30000001-0000-0000-0000-000000000015-2'), '30000001-0000-0000-0000-000000000015', 'Which keyword is used to emit values from an `async*` generator in Dart?', '["return", "emit", "yield", "send"]'::jsonb, 2, 'yield emits a single value from an async* generator function.', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-30000001-0000-0000-0000-000000000015-3'), '30000001-0000-0000-0000-000000000015', 'What type of Stream allows multiple subscribers?', '["Single-subscription stream", "BroadcastStream", "BufferedStream", "IsolateStream"]'::jsonb, 1, 'A BroadcastStream allows multiple listeners simultaneously.', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-30000001-0000-0000-0000-000000000015-4'), '30000001-0000-0000-0000-000000000015', 'FINAL WHIRLPOOL: Which function transforms each event of a Stream asynchronously?', '["stream.filter()", "stream.asyncMap()", "stream.forEach()", "stream.combine()"]'::jsonb, 1, 'asyncMap() applies an asynchronous function to each item emitted by the stream.', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;

-- Boss: Java Basics Boss (40000001-0000-0000-0000-000000000005)
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-40000001-0000-0000-0000-000000000005-1'), '40000001-0000-0000-0000-000000000005', 'The Java Sentinel asks: What is the size of a `long` in Java?', '["32 bits", "64 bits", "128 bits", "Platform dependent"]'::jsonb, 1, 'In Java, a long is always 64 bits (8 bytes) on all platforms.', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-40000001-0000-0000-0000-000000000005-2'), '40000001-0000-0000-0000-000000000005', 'Where is an object created with `new` stored in memory?', '["Stack", "Heap", "Register", "Code segment"]'::jsonb, 1, 'All objects in Java are allocated on the Heap memory.', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-40000001-0000-0000-0000-000000000005-3'), '40000001-0000-0000-0000-000000000005', 'What happens if you compare two String objects using `==` instead of `.equals()`?', '["It compares string characters", "It compares memory references, not text content", "Compilation error", "Throws NullPointerException"]'::jsonb, 1, '== compares reference identity, .equals() compares the actual character contents.', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-40000001-0000-0000-0000-000000000005-4'), '40000001-0000-0000-0000-000000000005', 'FINAL THUNDER: Can an abstract class in Java have constructors?', '["No, abstract classes cannot have constructors", "Yes, called via super() from subclasses", "Only private constructors", "Only static constructors"]'::jsonb, 1, 'Abstract classes can have constructors to initialize fields for their subclasses.', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;

-- Boss: Java OOP Boss (40000001-0000-0000-0000-000000000010)
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-40000001-0000-0000-0000-000000000010-1'), '40000001-0000-0000-0000-000000000010', 'The JVM Juggernaut asks: Which access modifier makes a member accessible in the same package and subclasses?', '["private", "default (package-private)", "protected", "public"]'::jsonb, 2, 'protected allows access within the package and by subclasses anywhere.', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-40000001-0000-0000-0000-000000000010-2'), '40000001-0000-0000-0000-000000000010', 'What is method overloading in Java?', '["Same method name, different parameters", "Overriding a parent method with @Override", "Hiding static methods", "Making methods final"]'::jsonb, 0, 'Overloading occurs when two methods in the same class share a name but differ in parameter lists.', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-40000001-0000-0000-0000-000000000010-3'), '40000001-0000-0000-0000-000000000010', 'Can an interface in modern Java (8+) contain method implementations?', '["No, only abstract methods", "Yes, using default and static methods", "Only private methods", "Only main method"]'::jsonb, 1, 'Java 8 introduced default and static interface methods with bodies.', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-40000001-0000-0000-0000-000000000010-4'), '40000001-0000-0000-0000-000000000010', 'FINAL SLAM: What does marking a class as `final` accomplish?', '["The class cannot be instantiated", "The class cannot be subclassed (inherited from)", "All its fields are immutable", "It runs faster"]'::jsonb, 1, 'A final class cannot be extended by any other class (like java.lang.String).', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;

-- Boss: Stream Master Boss (40000001-0000-0000-0000-000000000015)
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-40000001-0000-0000-0000-000000000015-1'), '40000001-0000-0000-0000-000000000015', 'The Stream Master challenges: Is the Java Stream API intermediate operation `filter()` lazy or eager?', '["Eager (executes immediately)", "Lazy (executes only when terminal op is invoked)", "Depends on thread count", "Synchronous only"]'::jsonb, 1, 'Intermediate operations on Java streams are lazy and execute upon terminal operation.', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-40000001-0000-0000-0000-000000000015-2'), '40000001-0000-0000-0000-000000000015', 'Which of these is a terminal operation on a Java Stream?', '["map()", "filter()", "sorted()", "collect()"]'::jsonb, 3, 'collect() is a terminal operation that triggers stream evaluation and gathers results.', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-40000001-0000-0000-0000-000000000015-3'), '40000001-0000-0000-0000-000000000015', 'What does `Optional<T>` protect against in Java?', '["OutOfMemoryError", "NullPointerException", "StackOverflowError", "ClassCastException"]'::jsonb, 1, 'Optional is a container object used to represent the presence or absence of a value without null.', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-40000001-0000-0000-0000-000000000015-4'), '40000001-0000-0000-0000-000000000015', 'FINAL STREAM: What is the purpose of `parallelStream()`?', '["Runs the stream on GPU", "Executes pipeline in parallel using ForkJoinPool", "Saves results to disk", "Bypasses JVM sandbox"]'::jsonb, 1, 'parallelStream() partitions work across multiple worker threads using the common ForkJoinPool.', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;

-- Boss: Memory Demon Boss (50000001-0000-0000-0000-000000000005)
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-50000001-0000-0000-0000-000000000005-1'), '50000001-0000-0000-0000-000000000005', 'The Memory Demon demands: What operator retrieves the memory address of a variable in C++?', '["*", "&", "->", "@"]'::jsonb, 1, 'The address-of operator & returns the memory address of a variable.', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-50000001-0000-0000-0000-000000000005-2'), '50000001-0000-0000-0000-000000000005', 'What happens if you `new` an object in C++ and never `delete` it?', '["Garbage collector cleans it", "Memory leak", "Segmentation fault immediately", "Compiler error"]'::jsonb, 1, 'C++ does not have a garbage collector, allocated heap memory leaks if not freed.', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-50000001-0000-0000-0000-000000000005-3'), '50000001-0000-0000-0000-000000000005', 'What does `int* const p` declare in C++?', '["A pointer to a constant int", "A constant pointer to an int (pointer cannot change address)", "A constant int reference", "Invalid syntax"]'::jsonb, 1, 'The pointer itself is constant, meaning it cannot point to another address.', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-50000001-0000-0000-0000-000000000005-4'), '50000001-0000-0000-0000-000000000005', 'FINAL EXORCISM: What is a dangling pointer?', '["A pointer pointing to nullptr", "A pointer pointing to deallocated memory", "An uninitialized pointer", "A void pointer"]'::jsonb, 1, 'A dangling pointer still holds the address of memory that has already been deleted or freed.', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;

-- Boss: Vtable Vampire Boss (50000001-0000-0000-0000-000000000010)
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-50000001-0000-0000-0000-000000000010-1'), '50000001-0000-0000-0000-000000000010', 'The Vtable Vampire strikes! Why should base class destructors be marked `virtual` in C++?', '["To prevent memory allocation", "To ensure the derived class destructor runs on deletion via base pointer", "To make the class abstract", "To inline the destructor"]'::jsonb, 1, 'A virtual destructor ensures the derived destructor executes when deleting via a base pointer.', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-50000001-0000-0000-0000-000000000010-2'), '50000001-0000-0000-0000-000000000010', 'What is a pure virtual function in C++?', '["virtual void f() = 0,", "virtual void f() {}", "void f() pure,", "inline virtual void f(),"]'::jsonb, 0, 'A pure virtual function (= 0) makes the class abstract and must be implemented by concrete subclasses.', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-50000001-0000-0000-0000-000000000010-3'), '50000001-0000-0000-0000-000000000010', 'What is the Vtable in C++?', '["A table storing local variables", "A table of function pointers for dynamic polymorphism lookup", "A vector of strings", "The compiler AST"]'::jsonb, 1, 'The virtual table (vtable) stores pointers to virtual functions for runtime method dispatch.', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-50000001-0000-0000-0000-000000000010-4'), '50000001-0000-0000-0000-000000000010', 'FINAL STAKE: What does `dynamic_cast` do in C++?', '["Converts types at compile time without checking", "Safely downcasts polymorphic pointers with runtime check", "Reinterprets raw bits", "Casts away constness"]'::jsonb, 1, 'dynamic_cast safely navigates an inheritance hierarchy at runtime, returning nullptr on pointer failure.', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;

-- Boss: STL Sorcerer Boss (50000001-0000-0000-0000-000000000015)
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-50000001-0000-0000-0000-000000000015-1'), '50000001-0000-0000-0000-000000000015', 'The STL Sorcerer asks: What is the time complexity of lookup in `std::unordered_map` on average?', '["O(1)", "O(log n)", "O(n)", "O(n log n)"]'::jsonb, 0, 'unordered_map uses a hash table providing O(1) average lookup complexity.', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-50000001-0000-0000-0000-000000000015-2'), '50000001-0000-0000-0000-000000000015', 'Which header is required to use `std::sort`?', '["<sort>", "<vector>", "<algorithm>", "<utility>"]'::jsonb, 2, 'std::sort is defined in the <algorithm> standard header.', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-50000001-0000-0000-0000-000000000015-3'), '50000001-0000-0000-0000-000000000015', 'What does `std::move` actually do in modern C++?', '["Copies the data on a background thread", "Casts an expression to an rvalue reference", "Frees the source memory", "Creates a shared pointer"]'::jsonb, 1, 'std::move performs an unconditional cast to an rvalue reference, enabling move semantics.', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-50000001-0000-0000-0000-000000000015-4'), '50000001-0000-0000-0000-000000000015', 'FINAL SPELL: Which smart pointer ensures exclusive, unique ownership of a heap resource in C++11?', '["std::shared_ptr", "std::unique_ptr", "std::weak_ptr", "std::auto_ptr"]'::jsonb, 1, 'std::unique_ptr manages a unique heap resource that cannot be copied, only moved.', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;

-- Boss: C Foundations Boss (60000001-0000-0000-0000-000000000005)
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-60000001-0000-0000-0000-000000000005-1'), '60000001-0000-0000-0000-000000000005', 'The Segfault Specter haunts: What character terminates all valid C strings in memory?', '["''\\n''", "''\\0'' (null character)", "EOF", "'' ''"]'::jsonb, 1, 'C strings are null-terminated character arrays ending in ''\0'' (ASCII 0).', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-60000001-0000-0000-0000-000000000005-2'), '60000001-0000-0000-0000-000000000005', 'What does `sizeof(char)` evaluate to according to the C standard?', '["1 byte always", "4 bytes", "Depends on 32-bit vs 64-bit", "2 bytes"]'::jsonb, 0, 'The C specification guarantees sizeof(char) is exactly 1 byte.', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-60000001-0000-0000-0000-000000000005-3'), '60000001-0000-0000-0000-000000000005', 'What is undefined behavior in C?', '["A compile-time error", "Execution where the C standard imposes no requirements (crashes, bugs)", "A warning message", "A safe exception"]'::jsonb, 1, 'Undefined behavior means anything can happen: data corruption, silent bugs, or crashes.', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-60000001-0000-0000-0000-000000000005-4'), '60000001-0000-0000-0000-000000000005', 'FINAL ATTACK: What does `scanf("%s", buffer)` lack that makes it unsafe?', '["It doesn''t support letters", "It does not limit the number of characters read, risking buffer overflow", "It requires root privileges", "It is deprecated"]'::jsonb, 1, 'Without a field width limit (like %99s), scanf can overflow the buffer.', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;

-- Boss: Array Boss (60000001-0000-0000-0000-000000000010)
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-60000001-0000-0000-0000-000000000010-1'), '60000001-0000-0000-0000-000000000010', 'The Array Overlord attacks: What happens when an array name is passed to a function in C?', '["A full copy of the array is made", "It decays into a pointer to its first element", "It causes a compile error", "It is converted to a struct"]'::jsonb, 1, 'Arrays decay to pointers to their first element when passed as function arguments.', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-60000001-0000-0000-0000-000000000010-2'), '60000001-0000-0000-0000-000000000010', 'What is `*(arr + 3)` equivalent to in C?', '["arr[3]", "arr + 3", "&arr[3]", "arr[0] + 3"]'::jsonb, 0, 'Array indexing arr[i] is defined as *(arr + i) by pointer arithmetic.', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-60000001-0000-0000-0000-000000000010-3'), '60000001-0000-0000-0000-000000000010', 'Which function compares two C strings lexicographically?', '["string_cmp()", "strcmp()", "memcmp()", "equals()"]'::jsonb, 1, 'strcmp(s1, s2) from <string.h> returns 0 if strings are identical.', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-60000001-0000-0000-0000-000000000010-4'), '60000001-0000-0000-0000-000000000010', 'FINAL SLICE: What is the size of `int arr[5],` on a system where sizeof(int) is 4?', '["5 bytes", "20 bytes", "4 bytes", "40 bytes"]'::jsonb, 1, '5 elements * 4 bytes each = 20 bytes total in contiguous memory.', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;

-- Boss: Memory Allocator Boss (60000001-0000-0000-0000-000000000015)
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-60000001-0000-0000-0000-000000000015-1'), '60000001-0000-0000-0000-000000000015', 'The Memory Allocator Boss demands: What does `malloc` do if allocation fails?', '["Throws an exception", "Returns NULL", "Terminates the program", "Returns a zeroed buffer"]'::jsonb, 1, 'malloc returns NULL when system memory cannot be allocated.', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-60000001-0000-0000-0000-000000000015-2'), '60000001-0000-0000-0000-000000000015', 'What is the key difference between `malloc` and `calloc`?', '["calloc is on the stack", "calloc initializes allocated memory to zero", "calloc cannot be freed", "malloc takes two arguments"]'::jsonb, 1, 'calloc takes count and size, and zeros out all allocated memory bytes.', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-60000001-0000-0000-0000-000000000015-3'), '60000001-0000-0000-0000-000000000015', 'What is a double-free bug?', '["Allocating memory twice", "Calling free() twice on the same memory address", "Doubling heap size", "Freeing a null pointer"]'::jsonb, 1, 'Calling free() twice on the same pointer corrupts the heap and causes security vulnerabilities.', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-boss-60000001-0000-0000-0000-000000000015-4'), '60000001-0000-0000-0000-000000000015', 'FINAL PURGE: What should you always set a pointer to immediately after freeing it?', '["1", "NULL", "EOF", "Leave it unchanged"]'::jsonb, 1, 'Setting p = NULL prevents dangling pointer reads and makes subsequent free(p) safe.', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options, correct_option_index=EXCLUDED.correct_option_index;

-- =============================================================================
-- D. POPULATE 13 EMPTY PYTHON CHAPTERS
-- =============================================================================
-- Chapter 3: Operators (72eae24a-344c-4d75-ab9b-1b82998161cc)
UPDATE chapters SET title='Operators', description='Arithmetic, comparison, and logical operators in Python', icon_emoji='🧮', order_index=3, unlock_requirement=0, total_lessons=4 WHERE id='72eae24a-344c-4d75-ab9b-1b82998161cc';
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch3-l1'), '72eae24a-344c-4d75-ab9b-1b82998161cc', 'python', 'Arithmetic Operators', 'Master +, -, *, /, //, %, ** in Python', 'theory', 'beginner', 1, 50, 10, $content$# Python Arithmetic Operators

Python provides powerful mathematical operators:

```python
a, b = 17, 5

print(a + b)   # 22 (Addition)
print(a - b)   # 12 (Subtraction)
print(a * b)   # 85 (Multiplication)
print(a / b)   # 3.4 (Float Division)
print(a // b)  # 3 (Floor Division)
print(a % b)   # 2 (Modulo / Remainder)
print(a ** b)  # 1419857 (Exponentiation: 17^5)
```

## Operator Precedence (PEMDAS)
Parentheses > Exponents > Multiplication/Division > Addition/Subtraction.$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch3-l2'), '72eae24a-344c-4d75-ab9b-1b82998161cc', 'python', 'Comparison & Logical Operators', 'Evaluate boolean expressions with comparisons', 'theory', 'beginner', 2, 50, 10, $content$# Comparison & Logical Operators

## Comparison Operators
```python
x, y = 10, 20
print(x == y)  # False
print(x != y)  # True
print(x < y)   # True
print(x >= y)  # False
```

## Logical Operators
- `and`: True if both are True
- `or`: True if at least one is True
- `not`: Inverts boolean

```python
age = 22
has_license = True
can_drive = age >= 18 and has_license
print(can_drive)  # True
```$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch3-l3'), '72eae24a-344c-4d75-ab9b-1b82998161cc', 'python', 'Operators Quiz', 'Test your knowledge of Python operators', 'quiz', 'beginner', 3, 40, 15, NULL, ARRAY['python', 'quiz'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch3-l3-1'), cq_id('py-ch3-l3'), 'Quiz question 1 on Operators', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 1 on Operators', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch3-l3-2'), cq_id('py-ch3-l3'), 'Quiz question 2 on Operators', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 2 on Operators', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch3-l3-3'), cq_id('py-ch3-l3'), 'Quiz question 3 on Operators', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 3 on Operators', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch3-l3-4'), cq_id('py-ch3-l3'), 'Quiz question 4 on Operators', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 4 on Operators', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch3-l4'), '72eae24a-344c-4d75-ab9b-1b82998161cc', 'python', 'Modulo Even-Odd Checker', 'Use modulo to classify numbers', 'coding', 'beginner', 4, 100, 25, NULL, ARRAY['python', 'coding'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-py-ch3-l4'), cq_id('py-ch3-l4'), 'python', 'Modulo Even-Odd Checker', 'Use modulo to classify numbers', '# Coding challenge for Operators
def solution():
    pass

print(solution())', '# Solution for Operators
def solution():
    return ''CodeQuest Complete''

print(solution())', '["Review the chapter theory", "Test your edge cases"]'::jsonb, 'beginner', 100, 25, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, starter_code=EXCLUDED.starter_code, solution_code=EXCLUDED.solution_code;

-- Chapter 4: Strings (9176a330-ecbf-4448-ad4a-77b210f6812f)
UPDATE chapters SET title='Strings', description='String indexing, slicing, methods and f-strings', icon_emoji='📝', order_index=4, unlock_requirement=0, total_lessons=4 WHERE id='9176a330-ecbf-4448-ad4a-77b210f6812f';
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch4-l1'), '9176a330-ecbf-4448-ad4a-77b210f6812f', 'python', 'String Indexing & Slicing', 'Extract characters and substrings', 'theory', 'beginner', 1, 50, 10, $content$# String Indexing & Slicing

Strings in Python are zero-indexed sequences of characters.

```python
text = "CodeQuest"

# Indexing
print(text[0])    # 'C'
print(text[-1])   # 't' (last character)

# Slicing [start:stop:step]
print(text[0:4])   # 'Code'
print(text[4:])    # 'Quest'
print(text[::-1])  # 'tseuQedoC' (reversed!)
```$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch4-l2'), '9176a330-ecbf-4448-ad4a-77b210f6812f', 'python', 'Essential String Methods', 'Transform and manipulate text effortlessly', 'theory', 'beginner', 2, 50, 10, $content$# Essential String Methods

Python strings have dozens of built-in methods:

```python
msg = "  Welcome to Cyber City  "

print(msg.strip())            # Removes leading/trailing spaces
print(msg.lower())            # Lowercase
print(msg.upper())            # Uppercase
print(msg.replace("Cyber", "Code")) # Replace word

words = "apple,banana,cherry".split(",")
print(words)                  # ['apple', 'banana', 'cherry']
print("-".join(words))        # 'apple-banana-cherry'
```$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch4-l3'), '9176a330-ecbf-4448-ad4a-77b210f6812f', 'python', 'Strings Quiz', 'Test your slicing and string method skills', 'quiz', 'beginner', 3, 40, 15, NULL, ARRAY['python', 'quiz'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch4-l3-1'), cq_id('py-ch4-l3'), 'Quiz question 1 on Strings', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 1 on Strings', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch4-l3-2'), cq_id('py-ch4-l3'), 'Quiz question 2 on Strings', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 2 on Strings', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch4-l3-3'), cq_id('py-ch4-l3'), 'Quiz question 3 on Strings', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 3 on Strings', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch4-l3-4'), cq_id('py-ch4-l3'), 'Quiz question 4 on Strings', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 4 on Strings', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch4-l4'), '9176a330-ecbf-4448-ad4a-77b210f6812f', 'python', 'Palindrome Detector', 'Check if a string reads the same backwards', 'coding', 'beginner', 4, 100, 25, NULL, ARRAY['python', 'coding'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-py-ch4-l4'), cq_id('py-ch4-l4'), 'python', 'Palindrome Detector', 'Check if a string reads the same backwards', '# Coding challenge for Strings
def solution():
    pass

print(solution())', '# Solution for Strings
def solution():
    return ''CodeQuest Complete''

print(solution())', '["Review the chapter theory", "Test your edge cases"]'::jsonb, 'beginner', 100, 25, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, starter_code=EXCLUDED.starter_code, solution_code=EXCLUDED.solution_code;

-- Chapter 5: Control Flow (a2bad866-cd1d-4cd9-bf1e-84ee73265f30)
UPDATE chapters SET title='Control Flow', description='Making decisions with if, elif, and else', icon_emoji='🔀', order_index=5, unlock_requirement=0, total_lessons=4 WHERE id='a2bad866-cd1d-4cd9-bf1e-84ee73265f30';
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch5-l1'), 'a2bad866-cd1d-4cd9-bf1e-84ee73265f30', 'python', 'The if-elif-else Statement', 'Guide execution flow with branching logic', 'theory', 'beginner', 1, 50, 10, $content$# Decision Making in Python

```python
score = 88

if score >= 90:
    grade = "A"
elif score >= 80:
    grade = "B"
elif score >= 70:
    grade = "C"
else:
    grade = "F"

print(f"Your grade is {grade}")
```

Remember: Python requires consistent indentation (4 spaces per level)!$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch5-l2'), 'a2bad866-cd1d-4cd9-bf1e-84ee73265f30', 'python', 'Ternary Operator & Truthiness', 'Clean one-line conditions in Python', 'theory', 'beginner', 2, 50, 10, $content$# Ternary Operator & Falsy Values

## Inline Ternary Expression
```python
status = "Adult" if age >= 18 else "Minor"
```

## Falsy Values in Python
The following evaluate to `False` in conditions:
- `None`, `False`
- `0`, `0.0`
- `""` (empty string)
- `[]`, `{}`, `set()` (empty collections)$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch5-l3'), 'a2bad866-cd1d-4cd9-bf1e-84ee73265f30', 'python', 'Control Flow Quiz', 'Test your understanding of branching logic', 'quiz', 'beginner', 3, 40, 15, NULL, ARRAY['python', 'quiz'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch5-l3-1'), cq_id('py-ch5-l3'), 'Quiz question 1 on Control Flow', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 1 on Control Flow', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch5-l3-2'), cq_id('py-ch5-l3'), 'Quiz question 2 on Control Flow', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 2 on Control Flow', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch5-l3-3'), cq_id('py-ch5-l3'), 'Quiz question 3 on Control Flow', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 3 on Control Flow', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch5-l3-4'), cq_id('py-ch5-l3'), 'Quiz question 4 on Control Flow', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 4 on Control Flow', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch5-l4'), 'a2bad866-cd1d-4cd9-bf1e-84ee73265f30', 'python', 'Leap Year Checker', 'Determine if a given year is a leap year', 'coding', 'beginner', 4, 100, 25, NULL, ARRAY['python', 'coding'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-py-ch5-l4'), cq_id('py-ch5-l4'), 'python', 'Leap Year Checker', 'Determine if a given year is a leap year', '# Coding challenge for Control Flow
def solution():
    pass

print(solution())', '# Solution for Control Flow
def solution():
    return ''CodeQuest Complete''

print(solution())', '["Review the chapter theory", "Test your edge cases"]'::jsonb, 'beginner', 100, 25, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, starter_code=EXCLUDED.starter_code, solution_code=EXCLUDED.solution_code;

-- Chapter 6: Loops (5ed3bbec-c986-4fbe-b12e-87ab153054ad)
UPDATE chapters SET title='Loops', description='For and while loops, range, and loop control', icon_emoji='🔄', order_index=6, unlock_requirement=1, total_lessons=4 WHERE id='5ed3bbec-c986-4fbe-b12e-87ab153054ad';
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch6-l1'), '5ed3bbec-c986-4fbe-b12e-87ab153054ad', 'python', 'For Loops & Range', 'Iterate over numbers, strings, and lists', 'theory', 'intermediate', 1, 60, 12, $content$# For Loops & range()

```python
# Count 0 to 4
for i in range(5):
    print(i)

# Count 10 to 50 stepping by 10
for n in range(10, 51, 10):
    print(n)

# Loop over items
heroes = ["Ninja", "Wizard", "Hacker"]
for hero in heroes:
    print(f"Hero: {hero}")
```$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch6-l2'), '5ed3bbec-c986-4fbe-b12e-87ab153054ad', 'python', 'While Loops & Control Statements', 'While loops, break, continue, and else', 'theory', 'intermediate', 2, 60, 12, $content$# While Loops & Loop Control

```python
count = 3
while count > 0:
    print(f"Countdown: {count}")
    count -= 1

# break & continue
for n in range(10):
    if n == 5:
        break     # stop loop completely
    if n % 2 == 0:
        continue  # skip even numbers
    print(n)      # prints 1, 3
```$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch6-l3'), '5ed3bbec-c986-4fbe-b12e-87ab153054ad', 'python', 'Loops Quiz', 'Master loop bounds and iteration control', 'quiz', 'intermediate', 3, 45, 15, NULL, ARRAY['python', 'quiz'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch6-l3-1'), cq_id('py-ch6-l3'), 'Quiz question 1 on Loops', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 1 on Loops', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch6-l3-2'), cq_id('py-ch6-l3'), 'Quiz question 2 on Loops', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 2 on Loops', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch6-l3-3'), cq_id('py-ch6-l3'), 'Quiz question 3 on Loops', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 3 on Loops', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch6-l3-4'), cq_id('py-ch6-l3'), 'Quiz question 4 on Loops', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 4 on Loops', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch6-l4'), '5ed3bbec-c986-4fbe-b12e-87ab153054ad', 'python', 'FizzBuzz Pro', 'The classic multi-condition loop problem', 'coding', 'intermediate', 4, 120, 30, NULL, ARRAY['python', 'coding'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-py-ch6-l4'), cq_id('py-ch6-l4'), 'python', 'FizzBuzz Pro', 'The classic multi-condition loop problem', '# Coding challenge for Loops
def solution():
    pass

print(solution())', '# Solution for Loops
def solution():
    return ''CodeQuest Complete''

print(solution())', '["Review the chapter theory", "Test your edge cases"]'::jsonb, 'intermediate', 120, 30, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, starter_code=EXCLUDED.starter_code, solution_code=EXCLUDED.solution_code;

-- Chapter 7: Functions (737cb9c1-1684-464a-bfe9-4329c64a9b0a)
UPDATE chapters SET title='Functions', description='Define functions, return values, parameters and scope', icon_emoji='⚙️', order_index=7, unlock_requirement=1, total_lessons=4 WHERE id='737cb9c1-1684-464a-bfe9-4329c64a9b0a';
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch7-l1'), '737cb9c1-1684-464a-bfe9-4329c64a9b0a', 'python', 'Defining & Calling Functions', 'Write reusable modular code blocks', 'theory', 'intermediate', 1, 60, 12, $content$# Python Functions

```python
def greet_player(name, title="Adventurer"):
    return f"Greetings, {title} {name}!"

msg = greet_player("Gokul", "Grandmaster")
print(msg)
```

Use `def` to define, specify arguments, and use `return` to send results back.$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch7-l2'), '737cb9c1-1684-464a-bfe9-4329c64a9b0a', 'python', 'Variable Scope & Lambda Functions', 'Local vs global scope and anonymous functions', 'theory', 'intermediate', 2, 60, 12, $content$# Scope & Lambdas

```python
x = 100  # Global

def demo():
    x = 10  # Local to demo()
    return x

# Lambda: anonymous one-line functions
square = lambda n: n * n
print(square(5))  # 25

# Commonly used with sorted()
leaderboard = [("Alice", 95), ("Bob", 88)]
leaderboard.sort(key=lambda s: s[1], reverse=True)
```$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch7-l3'), '737cb9c1-1684-464a-bfe9-4329c64a9b0a', 'python', 'Functions Quiz', 'Test parameter passing, scope and lambdas', 'quiz', 'intermediate', 3, 45, 15, NULL, ARRAY['python', 'quiz'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch7-l3-1'), cq_id('py-ch7-l3'), 'Quiz question 1 on Functions', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 1 on Functions', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch7-l3-2'), cq_id('py-ch7-l3'), 'Quiz question 2 on Functions', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 2 on Functions', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch7-l3-3'), cq_id('py-ch7-l3'), 'Quiz question 3 on Functions', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 3 on Functions', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch7-l3-4'), cq_id('py-ch7-l3'), 'Quiz question 4 on Functions', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 4 on Functions', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch7-l4'), '737cb9c1-1684-464a-bfe9-4329c64a9b0a', 'python', 'Temperature Converter Function', 'Convert between Celsius and Fahrenheit', 'coding', 'intermediate', 4, 120, 30, NULL, ARRAY['python', 'coding'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-py-ch7-l4'), cq_id('py-ch7-l4'), 'python', 'Temperature Converter Function', 'Convert between Celsius and Fahrenheit', '# Coding challenge for Functions
def solution():
    pass

print(solution())', '# Solution for Functions
def solution():
    return ''CodeQuest Complete''

print(solution())', '["Review the chapter theory", "Test your edge cases"]'::jsonb, 'intermediate', 120, 30, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, starter_code=EXCLUDED.starter_code, solution_code=EXCLUDED.solution_code;

-- Chapter 8: Modules & Packages (5c72f608-d25d-4202-b473-6fa7cd40714a)
UPDATE chapters SET title='Modules & Packages', description='Using standard library modules and creating custom ones', icon_emoji='📦', order_index=8, unlock_requirement=1, total_lessons=4 WHERE id='5c72f608-d25d-4202-b473-6fa7cd40714a';
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch8-l1'), '5c72f608-d25d-4202-b473-6fa7cd40714a', 'python', 'The Standard Library', 'Explore math, random, datetime, and sys', 'theory', 'intermediate', 1, 60, 12, $content$# Python Standard Library

```python
import math
import random
from datetime import datetime

print(math.sqrt(144))       # 12.0
print(math.pi)              # 3.14159265...

roll = random.randint(1, 6) # Dice roll 1-6
print(f"Rolled: {roll}")

now = datetime.now()
print(now.strftime("%Y-%m-%d"))
```$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch8-l2'), '5c72f608-d25d-4202-b473-6fa7cd40714a', 'python', 'Creating & Importing Modules', 'Organize large projects into clean modules', 'theory', 'intermediate', 2, 60, 12, $content$# Modular Python Architecture

```python
# In my_math.py:
def add(a, b): return a + b

# In main.py:
import my_math
print(my_math.add(5, 7))

# Or selective import:
from my_math import add
```

The `if __name__ == '__main__':` idiom ensures script code only runs when executed directly, not on import.$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch8-l3'), '5c72f608-d25d-4202-b473-6fa7cd40714a', 'python', 'Modules Quiz', 'Verify your knowledge of imports and packages', 'quiz', 'intermediate', 3, 45, 15, NULL, ARRAY['python', 'quiz'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch8-l3-1'), cq_id('py-ch8-l3'), 'Quiz question 1 on Modules & Packages', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 1 on Modules & Packages', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch8-l3-2'), cq_id('py-ch8-l3'), 'Quiz question 2 on Modules & Packages', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 2 on Modules & Packages', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch8-l3-3'), cq_id('py-ch8-l3'), 'Quiz question 3 on Modules & Packages', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 3 on Modules & Packages', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch8-l3-4'), cq_id('py-ch8-l3'), 'Quiz question 4 on Modules & Packages', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 4 on Modules & Packages', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch8-l4'), '5c72f608-d25d-4202-b473-6fa7cd40714a', 'python', 'Random Dice Roller', 'Build a configurable multi-dice simulator', 'coding', 'intermediate', 4, 120, 30, NULL, ARRAY['python', 'coding'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-py-ch8-l4'), cq_id('py-ch8-l4'), 'python', 'Random Dice Roller', 'Build a configurable multi-dice simulator', '# Coding challenge for Modules & Packages
def solution():
    pass

print(solution())', '# Solution for Modules & Packages
def solution():
    return ''CodeQuest Complete''

print(solution())', '["Review the chapter theory", "Test your edge cases"]'::jsonb, 'intermediate', 120, 30, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, starter_code=EXCLUDED.starter_code, solution_code=EXCLUDED.solution_code;

-- Chapter 9: Error Handling (d03ed110-a9e6-4465-94b4-773aef1b30c9)
UPDATE chapters SET title='Error Handling', description='Try, except, finally, and robust defensive coding', icon_emoji='🛡️', order_index=9, unlock_requirement=1, total_lessons=4 WHERE id='d03ed110-a9e6-4465-94b4-773aef1b30c9';
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch9-l1'), 'd03ed110-a9e6-4465-94b4-773aef1b30c9', 'python', 'Try / Except Blocks', 'Catch and recover from runtime exceptions gracefully', 'theory', 'intermediate', 1, 60, 12, $content$# Exception Handling in Python

```python
try:
    num = int(input("Enter number: "))
    result = 100 / num
    print(f"Result: {result}")
except ZeroDivisionError:
    print("Cannot divide by zero!")
except ValueError:
    print("Please enter a valid integer!")
except Exception as e:
    print(f"Unexpected error: {e}")
```$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch9-l2'), 'd03ed110-a9e6-4465-94b4-773aef1b30c9', 'python', 'Finally & Custom Exceptions', 'Cleanup resources and define domain errors', 'theory', 'intermediate', 2, 60, 12, $content$# Finally & Custom Exceptions

```python
# Finally always executes:
try:
    f = open("data.txt", "r")
finally:
    print("Cleanup block always runs")

# Custom Exception
class InsufficientBalanceError(Exception):
    pass

def withdraw(balance, amount):
    if amount > balance:
        raise InsufficientBalanceError("Not enough funds")
    return balance - amount
```$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch9-l3'), 'd03ed110-a9e6-4465-94b4-773aef1b30c9', 'python', 'Error Handling Quiz', 'Identify exception types and execution order', 'quiz', 'intermediate', 3, 45, 15, NULL, ARRAY['python', 'quiz'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch9-l3-1'), cq_id('py-ch9-l3'), 'Quiz question 1 on Error Handling', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 1 on Error Handling', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch9-l3-2'), cq_id('py-ch9-l3'), 'Quiz question 2 on Error Handling', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 2 on Error Handling', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch9-l3-3'), cq_id('py-ch9-l3'), 'Quiz question 3 on Error Handling', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 3 on Error Handling', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch9-l3-4'), cq_id('py-ch9-l3'), 'Quiz question 4 on Error Handling', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 4 on Error Handling', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch9-l4'), 'd03ed110-a9e6-4465-94b4-773aef1b30c9', 'python', 'Safe Number Parser', 'Safely parse user input with default fallback', 'coding', 'intermediate', 4, 120, 30, NULL, ARRAY['python', 'coding'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-py-ch9-l4'), cq_id('py-ch9-l4'), 'python', 'Safe Number Parser', 'Safely parse user input with default fallback', '# Coding challenge for Error Handling
def solution():
    pass

print(solution())', '# Solution for Error Handling
def solution():
    return ''CodeQuest Complete''

print(solution())', '["Review the chapter theory", "Test your edge cases"]'::jsonb, 'intermediate', 120, 30, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, starter_code=EXCLUDED.starter_code, solution_code=EXCLUDED.solution_code;

-- Chapter 10: Mini Projects (6b0eca17-a913-47a3-b1de-6c55b4d212d7)
UPDATE chapters SET title='Mini Projects', description='Combine your skills into practical projects', icon_emoji='🚀', order_index=10, unlock_requirement=1, total_lessons=4 WHERE id='6b0eca17-a913-47a3-b1de-6c55b4d212d7';
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch10-l1'), '6b0eca17-a913-47a3-b1de-6c55b4d212d7', 'python', 'Project Architecture: CLI Tools', 'Structuring interactive console applications', 'theory', 'intermediate', 1, 60, 15, $content$# Structuring CLI Applications

Good command-line applications follow three steps:
1. **Input**: Read and sanitize arguments/data
2. **Processing**: Pure logic isolated in functions
3. **Output**: Formatted presentation to the user

```python
def calculate_discount(price, percent):
    return round(price * (1 - percent / 100), 2)

def main():
    price = 100.0
    final_price = calculate_discount(price, 15)
    print(f"Discounted: ${final_price}")

if __name__ == '__main__':
    main()
```$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch10-l2'), '6b0eca17-a913-47a3-b1de-6c55b4d212d7', 'python', 'State Machines in Python', 'Building state-driven loops for games and apps', 'theory', 'intermediate', 2, 60, 15, $content$# Game Loop & State Pattern

```python
game_state = {"running": True, "score": 0, "lives": 3}

while game_state["running"]:
    # Process action
    game_state["score"] += 10
    if game_state["score"] >= 50:
        print("Victory!")
        game_state["running"] = False
```$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch10-l3'), '6b0eca17-a913-47a3-b1de-6c55b4d212d7', 'python', 'Architecture Quiz', 'Test your software design fundamentals', 'quiz', 'intermediate', 3, 45, 15, NULL, ARRAY['python', 'quiz'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch10-l3-1'), cq_id('py-ch10-l3'), 'Quiz question 1 on Mini Projects', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 1 on Mini Projects', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch10-l3-2'), cq_id('py-ch10-l3'), 'Quiz question 2 on Mini Projects', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 2 on Mini Projects', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch10-l3-3'), cq_id('py-ch10-l3'), 'Quiz question 3 on Mini Projects', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 3 on Mini Projects', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch10-l3-4'), cq_id('py-ch10-l3'), 'Quiz question 4 on Mini Projects', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 4 on Mini Projects', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch10-l4'), '6b0eca17-a913-47a3-b1de-6c55b4d212d7', 'python', 'Password Generator Project', 'Generate secure random passwords with mixed character types', 'coding', 'intermediate', 4, 150, 35, NULL, ARRAY['python', 'coding'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-py-ch10-l4'), cq_id('py-ch10-l4'), 'python', 'Password Generator Project', 'Generate secure random passwords with mixed character types', '# Coding challenge for Mini Projects
def solution():
    pass

print(solution())', '# Solution for Mini Projects
def solution():
    return ''CodeQuest Complete''

print(solution())', '["Review the chapter theory", "Test your edge cases"]'::jsonb, 'intermediate', 150, 35, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, starter_code=EXCLUDED.starter_code, solution_code=EXCLUDED.solution_code;

-- Chapter 11: Lists & Dictionaries (ef3ab931-ab2c-443a-b538-080ee9609d58)
UPDATE chapters SET title='Lists & Dictionaries', description='Advanced list comprehensions, dict operations, and sets', icon_emoji='📚', order_index=11, unlock_requirement=2, total_lessons=4 WHERE id='ef3ab931-ab2c-443a-b538-080ee9609d58';
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch11-l1'), 'ef3ab931-ab2c-443a-b538-080ee9609d58', 'python', 'List Comprehensions & Slicing', 'Compact functional data transformations', 'theory', 'advanced', 1, 70, 15, $content$# Advanced Lists

```python
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# List comprehension: [expr for item in list if condition]
even_squares = [x**2 for x in numbers if x % 2 == 0]
print(even_squares)  # [4, 16, 36, 64, 100]

# Matrix flattening
grid = [[1, 2], [3, 4], [5, 6]]
flat = [val for row in grid for val in row]
print(flat)          # [1, 2, 3, 4, 5, 6]
```$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch11-l2'), 'ef3ab931-ab2c-443a-b538-080ee9609d58', 'python', 'Dictionaries & Set Algebra', 'Hashmaps, nested structures, and set operations', 'theory', 'advanced', 2, 70, 15, $content$# Dictionaries & Sets

```python
# Dict Comprehension
squares_map = {x: x**2 for x in range(1, 6)}

# Nested dict manipulation
player = {"name": "Alex", "stats": {"xp": 1250, "level": 5}}
print(player["stats"]["xp"])  # 1250

# Set algebra
a = {1, 2, 3, 4}
b = {3, 4, 5, 6}
print(a & b)  # Intersection: {3, 4}
print(a | b)  # Union: {1, 2, 3, 4, 5, 6}
print(a - b)  # Difference: {1, 2}
```$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch11-l3'), 'ef3ab931-ab2c-443a-b538-080ee9609d58', 'python', 'Collections Quiz', 'Challenge your list, dict, and set expertise', 'quiz', 'advanced', 3, 50, 15, NULL, ARRAY['python', 'quiz'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch11-l3-1'), cq_id('py-ch11-l3'), 'Quiz question 1 on Lists & Dictionaries', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 1 on Lists & Dictionaries', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch11-l3-2'), cq_id('py-ch11-l3'), 'Quiz question 2 on Lists & Dictionaries', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 2 on Lists & Dictionaries', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch11-l3-3'), cq_id('py-ch11-l3'), 'Quiz question 3 on Lists & Dictionaries', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 3 on Lists & Dictionaries', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch11-l3-4'), cq_id('py-ch11-l3'), 'Quiz question 4 on Lists & Dictionaries', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 4 on Lists & Dictionaries', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch11-l4'), 'ef3ab931-ab2c-443a-b538-080ee9609d58', 'python', 'Word Frequency Counter', 'Count word occurrences in text using a dictionary', 'coding', 'advanced', 4, 150, 35, NULL, ARRAY['python', 'coding'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-py-ch11-l4'), cq_id('py-ch11-l4'), 'python', 'Word Frequency Counter', 'Count word occurrences in text using a dictionary', '# Coding challenge for Lists & Dictionaries
def solution():
    pass

print(solution())', '# Solution for Lists & Dictionaries
def solution():
    return ''CodeQuest Complete''

print(solution())', '["Review the chapter theory", "Test your edge cases"]'::jsonb, 'advanced', 150, 35, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, starter_code=EXCLUDED.starter_code, solution_code=EXCLUDED.solution_code;

-- Chapter 12: Object-Oriented Programming (49239dad-5052-4467-9374-645f5c921c7c)
UPDATE chapters SET title='Object-Oriented Programming', description='Classes, objects, inheritance, encapsulation and dunder methods', icon_emoji='🏗️', order_index=12, unlock_requirement=2, total_lessons=4 WHERE id='49239dad-5052-4467-9374-645f5c921c7c';
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch12-l1'), '49239dad-5052-4467-9374-645f5c921c7c', 'python', 'Classes, Objects & __init__', 'Blueprint your domain models with OOP', 'theory', 'advanced', 1, 70, 15, $content$# OOP in Python

```python
class Character:
    def __init__(self, name, hp=100):
        self.name = name
        self._hp = hp  # protected attribute

    def take_damage(self, amount):
        self._hp = max(0, self._hp - amount)

    @property
    def is_alive(self):
        return self._hp > 0

hero = Character("Gokul", 120)
hero.take_damage(30)
print(hero.is_alive)  # True
```$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch12-l2'), '49239dad-5052-4467-9374-645f5c921c7c', 'python', 'Inheritance & Dunder Methods', 'Class hierarchies, super(), and magic methods', 'theory', 'advanced', 2, 70, 15, $content$# Inheritance & Dunder Methods

```python
class Mage(Character):
    def __init__(self, name, mana=50):
        super().__init__(name, hp=80)
        self.mana = mana

    def __str__(self):
        return f"Mage {self.name} (Mana: {self.mana})"

    def __len__(self):
        return self.mana

m = Mage("Zara", 100)
print(str(m))   # Mage Zara (Mana: 100)
print(len(m))   # 100
```$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch12-l3'), '49239dad-5052-4467-9374-645f5c921c7c', 'python', 'OOP Quiz', 'Test your knowledge of classes, inheritance and dunders', 'quiz', 'advanced', 3, 50, 15, NULL, ARRAY['python', 'quiz'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch12-l3-1'), cq_id('py-ch12-l3'), 'Quiz question 1 on Object-Oriented Programming', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 1 on Object-Oriented Programming', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch12-l3-2'), cq_id('py-ch12-l3'), 'Quiz question 2 on Object-Oriented Programming', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 2 on Object-Oriented Programming', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch12-l3-3'), cq_id('py-ch12-l3'), 'Quiz question 3 on Object-Oriented Programming', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 3 on Object-Oriented Programming', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch12-l3-4'), cq_id('py-ch12-l3'), 'Quiz question 4 on Object-Oriented Programming', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 4 on Object-Oriented Programming', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch12-l4'), '49239dad-5052-4467-9374-645f5c921c7c', 'python', 'Bank Account Class', 'Implement a bank account with deposit, withdraw and balance checks', 'coding', 'advanced', 4, 150, 35, NULL, ARRAY['python', 'coding'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-py-ch12-l4'), cq_id('py-ch12-l4'), 'python', 'Bank Account Class', 'Implement a bank account with deposit, withdraw and balance checks', '# Coding challenge for Object-Oriented Programming
def solution():
    pass

print(solution())', '# Solution for Object-Oriented Programming
def solution():
    return ''CodeQuest Complete''

print(solution())', '["Review the chapter theory", "Test your edge cases"]'::jsonb, 'advanced', 150, 35, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, starter_code=EXCLUDED.starter_code, solution_code=EXCLUDED.solution_code;

-- Chapter 13: File Handling (a346ceb4-2ffb-4426-a940-823637c8f6ab)
UPDATE chapters SET title='File Handling', description='Read, write, and safely manage files with context managers', icon_emoji='📂', order_index=13, unlock_requirement=2, total_lessons=4 WHERE id='a346ceb4-2ffb-4426-a940-823637c8f6ab';
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch13-l1'), 'a346ceb4-2ffb-4426-a940-823637c8f6ab', 'python', 'Reading & Writing Files', 'Work with text and CSV files on disk', 'theory', 'advanced', 1, 70, 15, $content$# File I/O in Python

Always use the `with` statement for automatic file closing:

```python
# Writing to a file
with open("output.txt", "w", encoding="utf-8") as f:
    f.write("Hello CodeQuest!\n")
    f.write("Line two.\n")

# Reading from a file
with open("output.txt", "r", encoding="utf-8") as f:
    for line in f:
        print(line.strip())
```$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch13-l2'), 'a346ceb4-2ffb-4426-a940-823637c8f6ab', 'python', 'CSV & JSON Parsing', 'Structured data exchange with built-in modules', 'theory', 'advanced', 2, 70, 15, $content$# CSV & JSON in Python

```python
import json

data = {"player": "Alex", "score": 2500, "badges": ["MVP", "Cyber"]}

# Serialize to string
json_str = json.dumps(data)

# Deserialize from string
parsed = json.loads(json_str)
print(parsed["score"])  # 2500
```$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch13-l3'), 'a346ceb4-2ffb-4426-a940-823637c8f6ab', 'python', 'File I/O Quiz', 'Test file modes, context managers, and parsing', 'quiz', 'advanced', 3, 50, 15, NULL, ARRAY['python', 'quiz'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch13-l3-1'), cq_id('py-ch13-l3'), 'Quiz question 1 on File Handling', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 1 on File Handling', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch13-l3-2'), cq_id('py-ch13-l3'), 'Quiz question 2 on File Handling', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 2 on File Handling', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch13-l3-3'), cq_id('py-ch13-l3'), 'Quiz question 3 on File Handling', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 3 on File Handling', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch13-l3-4'), cq_id('py-ch13-l3'), 'Quiz question 4 on File Handling', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 4 on File Handling', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch13-l4'), 'a346ceb4-2ffb-4426-a940-823637c8f6ab', 'python', 'Log File Parser', 'Parse log lines and count ERROR occurrences', 'coding', 'advanced', 4, 150, 35, NULL, ARRAY['python', 'coding'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-py-ch13-l4'), cq_id('py-ch13-l4'), 'python', 'Log File Parser', 'Parse log lines and count ERROR occurrences', '# Coding challenge for File Handling
def solution():
    pass

print(solution())', '# Solution for File Handling
def solution():
    return ''CodeQuest Complete''

print(solution())', '["Review the chapter theory", "Test your edge cases"]'::jsonb, 'advanced', 150, 35, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, starter_code=EXCLUDED.starter_code, solution_code=EXCLUDED.solution_code;

-- Chapter 14: APIs & Databases (116ca275-9cbc-4cd6-8d2d-12cf554ecfbf)
UPDATE chapters SET title='APIs & Databases', description='HTTP requests, REST APIs, JSON parsing and SQLite', icon_emoji='🌐', order_index=14, unlock_requirement=2, total_lessons=4 WHERE id='116ca275-9cbc-4cd6-8d2d-12cf554ecfbf';
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch14-l1'), '116ca275-9cbc-4cd6-8d2d-12cf554ecfbf', 'python', 'Working with REST APIs', 'HTTP GET/POST requests and JSON payloads', 'theory', 'advanced', 1, 80, 18, $content$# REST APIs with urllib/requests

```python
import json
import urllib.request

url = "https://api.github.com/users/octocat"
req = urllib.request.Request(url, headers={"User-Agent": "CodeQuest"})

with urllib.request.urlopen(req) as resp:
    data = json.loads(resp.read().decode())
    print(data["name"])  # The Octocat
```$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch14-l2'), '116ca275-9cbc-4cd6-8d2d-12cf554ecfbf', 'python', 'SQLite Database Basics', 'Lightweight relational databases with sqlite3', 'theory', 'advanced', 2, 80, 18, $content$# SQLite in Python

```python
import sqlite3

conn = sqlite3.connect(":memory:")  # In-memory DB
cursor = conn.cursor()

cursor.execute("CREATE TABLE player_data (player_name TEXT, points INT)")
cursor.execute("INSERT INTO player_data VALUES (?, ?)", ("Alex", 950))
conn.commit()

cursor.execute("SELECT * FROM player_data WHERE points > ?", (900,))
print(cursor.fetchall())  # [('Alex', 950)]
conn.close()
```$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch14-l3'), '116ca275-9cbc-4cd6-8d2d-12cf554ecfbf', 'python', 'APIs & Databases Quiz', 'Test your knowledge of HTTP codes and SQL queries', 'quiz', 'advanced', 3, 50, 15, NULL, ARRAY['python', 'quiz'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch14-l3-1'), cq_id('py-ch14-l3'), 'Quiz question 1 on APIs & Databases', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 1 on APIs & Databases', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch14-l3-2'), cq_id('py-ch14-l3'), 'Quiz question 2 on APIs & Databases', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 2 on APIs & Databases', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch14-l3-3'), cq_id('py-ch14-l3'), 'Quiz question 3 on APIs & Databases', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 3 on APIs & Databases', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch14-l3-4'), cq_id('py-ch14-l3'), 'Quiz question 4 on APIs & Databases', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 4 on APIs & Databases', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch14-l4'), '116ca275-9cbc-4cd6-8d2d-12cf554ecfbf', 'python', 'User Data Store', 'Store and query user records using SQLite syntax', 'coding', 'advanced', 4, 160, 40, NULL, ARRAY['python', 'coding'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-py-ch14-l4'), cq_id('py-ch14-l4'), 'python', 'User Data Store', 'Store and query user records using SQLite syntax', '# Coding challenge for APIs & Databases
def solution():
    pass

print(solution())', '# Solution for APIs & Databases
def solution():
    return ''CodeQuest Complete''

print(solution())', '["Review the chapter theory", "Test your edge cases"]'::jsonb, 'advanced', 160, 40, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, starter_code=EXCLUDED.starter_code, solution_code=EXCLUDED.solution_code;

-- Chapter 15: Advanced Python (07ac2e0a-c705-4369-b78e-12fb0a25355b)
UPDATE chapters SET title='Advanced Python', description='Decorators, generators, context managers and concurrency', icon_emoji='⚡', order_index=15, unlock_requirement=2, total_lessons=4 WHERE id='07ac2e0a-c705-4369-b78e-12fb0a25355b';
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch15-l1'), '07ac2e0a-c705-4369-b78e-12fb0a25355b', 'python', 'Decorators & Metaprogramming', 'Wrap and enhance functions dynamically', 'theory', 'expert', 1, 80, 20, $content$# Decorators in Python

```python
import time

def timer(func):
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        print(f"{func.__name__} took {time.time() - start:.4f}s")
        return result
    return wrapper

@timer
def heavy_calc():
    return sum(x**2 for x in range(100000))

heavy_calc()
```$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch15-l2'), '07ac2e0a-c705-4369-b78e-12fb0a25355b', 'python', 'Generators & Yield', 'Memory-efficient lazy evaluation with yield', 'theory', 'expert', 2, 80, 20, $content$# Generators & Yield

```python
def fibonacci_stream(limit):
    a, b = 0, 1
    for _ in range(limit):
        yield a
        a, b = b, a + b

# Memory efficient — generates one by one
for num in fibonacci_stream(8):
    print(num, end=" ")  # 0 1 1 2 3 5 8 13
```$content$, ARRAY['python', 'theory'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch15-l3'), '07ac2e0a-c705-4369-b78e-12fb0a25355b', 'python', 'Advanced Python Quiz', 'Prove your expertise in decorators, generators, and the GIL', 'quiz', 'expert', 3, 60, 20, NULL, ARRAY['python', 'quiz'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch15-l3-1'), cq_id('py-ch15-l3'), 'Quiz question 1 on Advanced Python', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 1 on Advanced Python', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch15-l3-2'), cq_id('py-ch15-l3'), 'Quiz question 2 on Advanced Python', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 2 on Advanced Python', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch15-l3-3'), cq_id('py-ch15-l3'), 'Quiz question 3 on Advanced Python', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 3 on Advanced Python', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-py-ch15-l3-4'), cq_id('py-ch15-l3'), 'Quiz question 4 on Advanced Python', '["Option A (Correct)", "Option B", "Option C", "Option D"]'::jsonb, 0, 'Explanation for question 4 on Advanced Python', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('py-ch15-l4'), '07ac2e0a-c705-4369-b78e-12fb0a25355b', 'python', 'Execution Timer Decorator', 'Build a decorator measuring execution time', 'coding', 'expert', 4, 200, 50, NULL, ARRAY['python', 'coding'], 10, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=EXCLUDED.is_active;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-py-ch15-l4'), cq_id('py-ch15-l4'), 'python', 'Execution Timer Decorator', 'Build a decorator measuring execution time', '# Coding challenge for Advanced Python
def solution():
    pass

print(solution())', '# Solution for Advanced Python
def solution():
    return ''CodeQuest Complete''

print(solution())', '["Review the chapter theory", "Test your edge cases"]'::jsonb, 'expert', 200, 50, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, starter_code=EXCLUDED.starter_code, solution_code=EXCLUDED.solution_code;

-- =============================================================================
-- E. LEVEL 2 & LEVEL 3 CHAPTERS & LESSONS FOR OTHER LANGUAGES
-- =============================================================================
-- ── JAVASCRIPT Level 2 & 3 Chapters ──
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('javascript-ch4'), 'javascript', 'Arrays & Objects', 'Deep dive into JS arrays, maps, and objects', 4, 1, 4, '📚', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch4-l1'), cq_id('javascript-ch4'), 'javascript', 'Array Methods: map, filter, reduce', 'Transform and aggregate arrays functionally', 'theory', 'intermediate', 1, 60, 15, $content$# Array Methods: map, filter, reduce\n\n## Overview\nTransform and aggregate arrays functionally.\n\n```\n// Example code for Array Methods: map, filter, reduce\n```$content$, ARRAY['javascript', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch4-l2'), cq_id('javascript-ch4'), 'javascript', 'Object Destructuring & Spread', 'Unpack properties and clone immutably', 'theory', 'intermediate', 2, 60, 15, $content$# Object Destructuring & Spread\n\n## Overview\nUnpack properties and clone immutably.\n\n```\n// Example code for Object Destructuring & Spread\n```$content$, ARRAY['javascript', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch4-l3'), cq_id('javascript-ch4'), 'javascript', 'Collections Quiz', 'Test your JS array and object mastery', 'quiz', 'intermediate', 3, 60, 15, $content$# Collections Quiz\n\n## Overview\nTest your JS array and object mastery.\n\n```\n// Example code for Collections Quiz\n```$content$, ARRAY['javascript', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch4-l3-1'), cq_id('javascript-ch4-l3'), 'Question 1: Collections Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Collections Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch4-l3-2'), cq_id('javascript-ch4-l3'), 'Question 2: Collections Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Collections Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch4-l3-3'), cq_id('javascript-ch4-l3'), 'Question 3: Collections Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Collections Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch4-l3-4'), cq_id('javascript-ch4-l3'), 'Question 4: Collections Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Collections Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch4-l4'), cq_id('javascript-ch4'), 'javascript', 'Array Transformation Pipeline', 'Chain filter and map to clean user data', 'coding', 'intermediate', 4, 60, 15, $content$# Array Transformation Pipeline\n\n## Overview\nChain filter and map to clean user data.\n\n```\n// Example code for Array Transformation Pipeline\n```$content$, ARRAY['javascript', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-javascript-ch4-l4'), cq_id('javascript-ch4-l4'), 'javascript', 'Array Transformation Pipeline', 'Chain filter and map to clean user data', '// Starter code for Array Transformation Pipeline in javascript', '// Solution code for Array Transformation Pipeline in javascript', '["Review the theory", "Check edge cases"]'::jsonb, 'intermediate', 100, 30, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('javascript-ch5'), 'javascript', 'DOM Manipulation', 'Selecting, creating, and modifying HTML nodes', 5, 1, 4, '🌐', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch5-l1'), cq_id('javascript-ch5'), 'javascript', 'Querying & Modifying the DOM', 'querySelector, innerHTML, and classList', 'theory', 'intermediate', 1, 60, 15, $content$# Querying & Modifying the DOM\n\n## Overview\nquerySelector, innerHTML, and classList.\n\n```\n// Example code for Querying & Modifying the DOM\n```$content$, ARRAY['javascript', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch5-l2'), cq_id('javascript-ch5'), 'javascript', 'Event Listeners & Event Object', 'Handle click, input, and keyboard events', 'theory', 'intermediate', 2, 60, 15, $content$# Event Listeners & Event Object\n\n## Overview\nHandle click, input, and keyboard events.\n\n```\n// Example code for Event Listeners & Event Object\n```$content$, ARRAY['javascript', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch5-l3'), cq_id('javascript-ch5'), 'javascript', 'DOM Quiz', 'Test your web DOM manipulation skills', 'quiz', 'intermediate', 3, 60, 15, $content$# DOM Quiz\n\n## Overview\nTest your web DOM manipulation skills.\n\n```\n// Example code for DOM Quiz\n```$content$, ARRAY['javascript', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch5-l3-1'), cq_id('javascript-ch5-l3'), 'Question 1: DOM Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for DOM Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch5-l3-2'), cq_id('javascript-ch5-l3'), 'Question 2: DOM Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for DOM Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch5-l3-3'), cq_id('javascript-ch5-l3'), 'Question 3: DOM Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for DOM Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch5-l3-4'), cq_id('javascript-ch5-l3'), 'Question 4: DOM Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for DOM Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch5-l4'), cq_id('javascript-ch5'), 'javascript', 'Dynamic Card Generator', 'Create DOM cards from an array of objects', 'coding', 'intermediate', 4, 60, 15, $content$# Dynamic Card Generator\n\n## Overview\nCreate DOM cards from an array of objects.\n\n```\n// Example code for Dynamic Card Generator\n```$content$, ARRAY['javascript', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-javascript-ch5-l4'), cq_id('javascript-ch5-l4'), 'javascript', 'Dynamic Card Generator', 'Create DOM cards from an array of objects', '// Starter code for Dynamic Card Generator in javascript', '// Solution code for Dynamic Card Generator in javascript', '["Review the theory", "Check edge cases"]'::jsonb, 'intermediate', 100, 30, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('javascript-ch6'), 'javascript', 'Async JavaScript', 'Promises, async/await, and the Fetch API', 6, 1, 4, '⏳', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch6-l1'), cq_id('javascript-ch6'), 'javascript', 'Promises & Chaining', 'Resolve, reject, and chaining with .then()', 'theory', 'intermediate', 1, 60, 15, $content$# Promises & Chaining\n\n## Overview\nResolve, reject, and chaining with .then().\n\n```\n// Example code for Promises & Chaining\n```$content$, ARRAY['javascript', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch6-l2'), cq_id('javascript-ch6'), 'javascript', 'Async/Await Syntax', 'Clean sequential asynchronous code', 'theory', 'intermediate', 2, 60, 15, $content$# Async/Await Syntax\n\n## Overview\nClean sequential asynchronous code.\n\n```\n// Example code for Async/Await Syntax\n```$content$, ARRAY['javascript', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch6-l3'), cq_id('javascript-ch6'), 'javascript', 'Async JS Quiz', 'Master async flow and microtasks', 'quiz', 'intermediate', 3, 60, 15, $content$# Async JS Quiz\n\n## Overview\nMaster async flow and microtasks.\n\n```\n// Example code for Async JS Quiz\n```$content$, ARRAY['javascript', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch6-l3-1'), cq_id('javascript-ch6-l3'), 'Question 1: Async JS Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Async JS Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch6-l3-2'), cq_id('javascript-ch6-l3'), 'Question 2: Async JS Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Async JS Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch6-l3-3'), cq_id('javascript-ch6-l3'), 'Question 3: Async JS Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Async JS Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch6-l3-4'), cq_id('javascript-ch6-l3'), 'Question 4: Async JS Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Async JS Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch6-l4'), cq_id('javascript-ch6'), 'javascript', 'Weather Data Fetcher', 'Simulate fetching and parsing JSON API data', 'coding', 'intermediate', 4, 60, 15, $content$# Weather Data Fetcher\n\n## Overview\nSimulate fetching and parsing JSON API data.\n\n```\n// Example code for Weather Data Fetcher\n```$content$, ARRAY['javascript', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-javascript-ch6-l4'), cq_id('javascript-ch6-l4'), 'javascript', 'Weather Data Fetcher', 'Simulate fetching and parsing JSON API data', '// Starter code for Weather Data Fetcher in javascript', '// Solution code for Weather Data Fetcher in javascript', '["Review the theory", "Check edge cases"]'::jsonb, 'intermediate', 100, 30, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('javascript-ch7'), 'javascript', 'Closures & Prototypes', 'Lexical scoping, closure patterns, and prototypes', 7, 2, 4, '🔗', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch7-l1'), cq_id('javascript-ch7'), 'javascript', 'Lexical Scope & Closures', 'Private state and function factories', 'theory', 'advanced', 1, 80, 20, $content$# Lexical Scope & Closures\n\n## Overview\nPrivate state and function factories.\n\n```\n// Example code for Lexical Scope & Closures\n```$content$, ARRAY['javascript', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch7-l2'), cq_id('javascript-ch7'), 'javascript', 'The Prototype Chain & ''this''', 'Inheritance and execution context in JS', 'theory', 'advanced', 2, 80, 20, $content$# The Prototype Chain & 'this'\n\n## Overview\nInheritance and execution context in JS.\n\n```\n// Example code for The Prototype Chain & 'this'\n```$content$, ARRAY['javascript', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch7-l3'), cq_id('javascript-ch7'), 'javascript', 'Closures Quiz', 'Deep dive into JS memory and scope', 'quiz', 'advanced', 3, 80, 20, $content$# Closures Quiz\n\n## Overview\nDeep dive into JS memory and scope.\n\n```\n// Example code for Closures Quiz\n```$content$, ARRAY['javascript', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch7-l3-1'), cq_id('javascript-ch7-l3'), 'Question 1: Closures Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Closures Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch7-l3-2'), cq_id('javascript-ch7-l3'), 'Question 2: Closures Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Closures Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch7-l3-3'), cq_id('javascript-ch7-l3'), 'Question 3: Closures Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Closures Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch7-l3-4'), cq_id('javascript-ch7-l3'), 'Question 4: Closures Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Closures Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch7-l4'), cq_id('javascript-ch7'), 'javascript', 'Memoization Cache', 'Implement a memoize wrapper function', 'coding', 'advanced', 4, 80, 20, $content$# Memoization Cache\n\n## Overview\nImplement a memoize wrapper function.\n\n```\n// Example code for Memoization Cache\n```$content$, ARRAY['javascript', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-javascript-ch7-l4'), cq_id('javascript-ch7-l4'), 'javascript', 'Memoization Cache', 'Implement a memoize wrapper function', '// Starter code for Memoization Cache in javascript', '// Solution code for Memoization Cache in javascript', '["Review the theory", "Check edge cases"]'::jsonb, 'advanced', 120, 35, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('javascript-ch8'), 'javascript', 'Modern ES6+ Features', 'Modules, generators, proxy, and symbols', 8, 2, 4, '🚀', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch8-l1'), cq_id('javascript-ch8'), 'javascript', 'ES Modules & Destructuring', 'import/export syntax and clean architectures', 'theory', 'advanced', 1, 80, 20, $content$# ES Modules & Destructuring\n\n## Overview\nimport/export syntax and clean architectures.\n\n```\n// Example code for ES Modules & Destructuring\n```$content$, ARRAY['javascript', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch8-l2'), cq_id('javascript-ch8'), 'javascript', 'Generators & Iterables', 'function* and custom iterators', 'theory', 'advanced', 2, 80, 20, $content$# Generators & Iterables\n\n## Overview\nfunction* and custom iterators.\n\n```\n// Example code for Generators & Iterables\n```$content$, ARRAY['javascript', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch8-l3'), cq_id('javascript-ch8'), 'javascript', 'ES6+ Quiz', 'Verify your modern JavaScript knowledge', 'quiz', 'advanced', 3, 80, 20, $content$# ES6+ Quiz\n\n## Overview\nVerify your modern JavaScript knowledge.\n\n```\n// Example code for ES6+ Quiz\n```$content$, ARRAY['javascript', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch8-l3-1'), cq_id('javascript-ch8-l3'), 'Question 1: ES6+ Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for ES6+ Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch8-l3-2'), cq_id('javascript-ch8-l3'), 'Question 2: ES6+ Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for ES6+ Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch8-l3-3'), cq_id('javascript-ch8-l3'), 'Question 3: ES6+ Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for ES6+ Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch8-l3-4'), cq_id('javascript-ch8-l3'), 'Question 4: ES6+ Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for ES6+ Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch8-l4'), cq_id('javascript-ch8'), 'javascript', 'Custom Range Generator', 'Create an iterable range generator function', 'coding', 'advanced', 4, 80, 20, $content$# Custom Range Generator\n\n## Overview\nCreate an iterable range generator function.\n\n```\n// Example code for Custom Range Generator\n```$content$, ARRAY['javascript', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-javascript-ch8-l4'), cq_id('javascript-ch8-l4'), 'javascript', 'Custom Range Generator', 'Create an iterable range generator function', '// Starter code for Custom Range Generator in javascript', '// Solution code for Custom Range Generator in javascript', '["Review the theory", "Check edge cases"]'::jsonb, 'advanced', 120, 35, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('javascript-ch9'), 'javascript', 'Functional Programming in JS', 'Pure functions, currying, and composition', 9, 2, 4, '♾️', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch9-l1'), cq_id('javascript-ch9'), 'javascript', 'Pure Functions & Immutability', 'Eliminate side-effects in code', 'theory', 'advanced', 1, 80, 20, $content$# Pure Functions & Immutability\n\n## Overview\nEliminate side-effects in code.\n\n```\n// Example code for Pure Functions & Immutability\n```$content$, ARRAY['javascript', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch9-l2'), cq_id('javascript-ch9'), 'javascript', 'Currying & Function Composition', 'Partial application and piping functions', 'theory', 'advanced', 2, 80, 20, $content$# Currying & Function Composition\n\n## Overview\nPartial application and piping functions.\n\n```\n// Example code for Currying & Function Composition\n```$content$, ARRAY['javascript', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch9-l3'), cq_id('javascript-ch9'), 'javascript', 'Functional JS Quiz', 'Test your FP paradigms in JavaScript', 'quiz', 'advanced', 3, 80, 20, $content$# Functional JS Quiz\n\n## Overview\nTest your FP paradigms in JavaScript.\n\n```\n// Example code for Functional JS Quiz\n```$content$, ARRAY['javascript', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch9-l3-1'), cq_id('javascript-ch9-l3'), 'Question 1: Functional JS Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Functional JS Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch9-l3-2'), cq_id('javascript-ch9-l3'), 'Question 2: Functional JS Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Functional JS Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch9-l3-3'), cq_id('javascript-ch9-l3'), 'Question 3: Functional JS Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Functional JS Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch9-l3-4'), cq_id('javascript-ch9-l3'), 'Question 4: Functional JS Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Functional JS Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('javascript-ch9-l4'), cq_id('javascript-ch9'), 'javascript', 'Boss Battle: Functional Master', 'Defeat the Side-Effect Spectre!', 'boss_battle', 'expert', 4, 200, 50, $content$# Boss Battle: Functional Master\n\n## Overview\nDefeat the Side-Effect Spectre!.\n\n```\n// Example code for Boss Battle: Functional Master\n```$content$, ARRAY['javascript', 'boss_battle'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch9-l4-1'), cq_id('javascript-ch9-l4'), 'Question 1: Boss Battle: Functional Master', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Boss Battle: Functional Master', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch9-l4-2'), cq_id('javascript-ch9-l4'), 'Question 2: Boss Battle: Functional Master', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Boss Battle: Functional Master', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch9-l4-3'), cq_id('javascript-ch9-l4'), 'Question 3: Boss Battle: Functional Master', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Boss Battle: Functional Master', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-javascript-ch9-l4-4'), cq_id('javascript-ch9-l4'), 'Question 4: Boss Battle: Functional Master', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Boss Battle: Functional Master', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;

-- ── DART Level 2 & 3 Chapters ──
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('dart-ch4'), 'dart', 'Collections in Dart', 'Lists, Maps, Sets and Iterables', 4, 1, 4, '📦', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch4-l1'), cq_id('dart-ch4'), 'dart', 'Lists & Mapping', 'Growable lists, map, where, and fold', 'theory', 'intermediate', 1, 60, 15, $content$# Lists & Mapping\n\n## Overview\nGrowable lists, map, where, and fold.\n\n```\n// Example code for Lists & Mapping\n```$content$, ARRAY['dart', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch4-l2'), cq_id('dart-ch4'), 'dart', 'Maps & Sets', 'Key-value pairs and unique collections', 'theory', 'intermediate', 2, 60, 15, $content$# Maps & Sets\n\n## Overview\nKey-value pairs and unique collections.\n\n```\n// Example code for Maps & Sets\n```$content$, ARRAY['dart', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch4-l3'), cq_id('dart-ch4'), 'dart', 'Collections Quiz', 'Test your Dart collections knowledge', 'quiz', 'intermediate', 3, 60, 15, $content$# Collections Quiz\n\n## Overview\nTest your Dart collections knowledge.\n\n```\n// Example code for Collections Quiz\n```$content$, ARRAY['dart', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch4-l3-1'), cq_id('dart-ch4-l3'), 'Question 1: Collections Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Collections Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch4-l3-2'), cq_id('dart-ch4-l3'), 'Question 2: Collections Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Collections Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch4-l3-3'), cq_id('dart-ch4-l3'), 'Question 3: Collections Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Collections Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch4-l3-4'), cq_id('dart-ch4-l3'), 'Question 4: Collections Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Collections Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch4-l4'), cq_id('dart-ch4'), 'dart', 'Cart Total Calculator', 'Calculate order totals with tax using fold', 'coding', 'intermediate', 4, 60, 15, $content$# Cart Total Calculator\n\n## Overview\nCalculate order totals with tax using fold.\n\n```\n// Example code for Cart Total Calculator\n```$content$, ARRAY['dart', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-dart-ch4-l4'), cq_id('dart-ch4-l4'), 'dart', 'Cart Total Calculator', 'Calculate order totals with tax using fold', '// Starter code for Cart Total Calculator in dart', '// Solution code for Cart Total Calculator in dart', '["Review the theory", "Check edge cases"]'::jsonb, 'intermediate', 100, 30, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('dart-ch5'), 'dart', 'Advanced OOP in Dart', 'Constructors, mixins, and abstract classes', 5, 1, 4, '🏗️', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch5-l1'), cq_id('dart-ch5'), 'dart', 'Constructors & Factory', 'Named, factory, and redirecting constructors', 'theory', 'intermediate', 1, 60, 15, $content$# Constructors & Factory\n\n## Overview\nNamed, factory, and redirecting constructors.\n\n```\n// Example code for Constructors & Factory\n```$content$, ARRAY['dart', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch5-l2'), cq_id('dart-ch5'), 'dart', 'Mixins & Interfaces', 'Code reuse with ''with'' and ''implements''', 'theory', 'intermediate', 2, 60, 15, $content$# Mixins & Interfaces\n\n## Overview\nCode reuse with 'with' and 'implements'.\n\n```\n// Example code for Mixins & Interfaces\n```$content$, ARRAY['dart', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch5-l3'), cq_id('dart-ch5'), 'dart', 'OOP Dart Quiz', 'Master class hierarchies in Dart', 'quiz', 'intermediate', 3, 60, 15, $content$# OOP Dart Quiz\n\n## Overview\nMaster class hierarchies in Dart.\n\n```\n// Example code for OOP Dart Quiz\n```$content$, ARRAY['dart', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch5-l3-1'), cq_id('dart-ch5-l3'), 'Question 1: OOP Dart Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for OOP Dart Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch5-l3-2'), cq_id('dart-ch5-l3'), 'Question 2: OOP Dart Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for OOP Dart Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch5-l3-3'), cq_id('dart-ch5-l3'), 'Question 3: OOP Dart Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for OOP Dart Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch5-l3-4'), cq_id('dart-ch5-l3'), 'Question 4: OOP Dart Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for OOP Dart Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch5-l4'), cq_id('dart-ch5'), 'dart', 'Vehicle Hierarchy System', 'Build vehicle classes with electric mixin', 'coding', 'intermediate', 4, 60, 15, $content$# Vehicle Hierarchy System\n\n## Overview\nBuild vehicle classes with electric mixin.\n\n```\n// Example code for Vehicle Hierarchy System\n```$content$, ARRAY['dart', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-dart-ch5-l4'), cq_id('dart-ch5-l4'), 'dart', 'Vehicle Hierarchy System', 'Build vehicle classes with electric mixin', '// Starter code for Vehicle Hierarchy System in dart', '// Solution code for Vehicle Hierarchy System in dart', '["Review the theory", "Check edge cases"]'::jsonb, 'intermediate', 100, 30, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('dart-ch6'), 'dart', 'Async Dart & Streams', 'Futures, Streams, and async/await', 6, 1, 4, '⏳', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch6-l1'), cq_id('dart-ch6'), 'dart', 'Futures & Async/Await', 'Asynchronous single-value computations', 'theory', 'intermediate', 1, 60, 15, $content$# Futures & Async/Await\n\n## Overview\nAsynchronous single-value computations.\n\n```\n// Example code for Futures & Async/Await\n```$content$, ARRAY['dart', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch6-l2'), cq_id('dart-ch6'), 'dart', 'Streams & AsyncGenerators', 'StreamController and async* generators', 'theory', 'intermediate', 2, 60, 15, $content$# Streams & AsyncGenerators\n\n## Overview\nStreamController and async* generators.\n\n```\n// Example code for Streams & AsyncGenerators\n```$content$, ARRAY['dart', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch6-l3'), cq_id('dart-ch6'), 'dart', 'Async Dart Quiz', 'Test your reactive Dart skills', 'quiz', 'intermediate', 3, 60, 15, $content$# Async Dart Quiz\n\n## Overview\nTest your reactive Dart skills.\n\n```\n// Example code for Async Dart Quiz\n```$content$, ARRAY['dart', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch6-l3-1'), cq_id('dart-ch6-l3'), 'Question 1: Async Dart Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Async Dart Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch6-l3-2'), cq_id('dart-ch6-l3'), 'Question 2: Async Dart Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Async Dart Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch6-l3-3'), cq_id('dart-ch6-l3'), 'Question 3: Async Dart Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Async Dart Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch6-l3-4'), cq_id('dart-ch6-l3'), 'Question 4: Async Dart Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Async Dart Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch6-l4'), cq_id('dart-ch6'), 'dart', 'Countdown Timer Stream', 'Emit seconds countdown using async*', 'coding', 'intermediate', 4, 60, 15, $content$# Countdown Timer Stream\n\n## Overview\nEmit seconds countdown using async*.\n\n```\n// Example code for Countdown Timer Stream\n```$content$, ARRAY['dart', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-dart-ch6-l4'), cq_id('dart-ch6-l4'), 'dart', 'Countdown Timer Stream', 'Emit seconds countdown using async*', '// Starter code for Countdown Timer Stream in dart', '// Solution code for Countdown Timer Stream in dart', '["Review the theory", "Check edge cases"]'::jsonb, 'intermediate', 100, 30, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('dart-ch7'), 'dart', 'Flutter Architecture', 'Widgets, state trees, and rendering', 7, 2, 4, '📱', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch7-l1'), cq_id('dart-ch7'), 'dart', 'Widget Tree & Element Tree', 'How Flutter renders pixels on screen', 'theory', 'advanced', 1, 80, 20, $content$# Widget Tree & Element Tree\n\n## Overview\nHow Flutter renders pixels on screen.\n\n```\n// Example code for Widget Tree & Element Tree\n```$content$, ARRAY['dart', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch7-l2'), cq_id('dart-ch7'), 'dart', 'BuildContext & Keys', 'Understanding widget identity and scope', 'theory', 'advanced', 2, 80, 20, $content$# BuildContext & Keys\n\n## Overview\nUnderstanding widget identity and scope.\n\n```\n// Example code for BuildContext & Keys\n```$content$, ARRAY['dart', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch7-l3'), cq_id('dart-ch7'), 'dart', 'Flutter Arch Quiz', 'Test widget lifecycle and architecture', 'quiz', 'advanced', 3, 80, 20, $content$# Flutter Arch Quiz\n\n## Overview\nTest widget lifecycle and architecture.\n\n```\n// Example code for Flutter Arch Quiz\n```$content$, ARRAY['dart', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch7-l3-1'), cq_id('dart-ch7-l3'), 'Question 1: Flutter Arch Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Flutter Arch Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch7-l3-2'), cq_id('dart-ch7-l3'), 'Question 2: Flutter Arch Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Flutter Arch Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch7-l3-3'), cq_id('dart-ch7-l3'), 'Question 3: Flutter Arch Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Flutter Arch Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch7-l3-4'), cq_id('dart-ch7-l3'), 'Question 4: Flutter Arch Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Flutter Arch Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch7-l4'), cq_id('dart-ch7'), 'dart', 'Custom Card Component', 'Build a reusable cyber styled card in Dart', 'coding', 'advanced', 4, 80, 20, $content$# Custom Card Component\n\n## Overview\nBuild a reusable cyber styled card in Dart.\n\n```\n// Example code for Custom Card Component\n```$content$, ARRAY['dart', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-dart-ch7-l4'), cq_id('dart-ch7-l4'), 'dart', 'Custom Card Component', 'Build a reusable cyber styled card in Dart', '// Starter code for Custom Card Component in dart', '// Solution code for Custom Card Component in dart', '["Review the theory", "Check edge cases"]'::jsonb, 'advanced', 120, 35, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('dart-ch8'), 'dart', 'State Management Patterns', 'Provider, Riverpod, and BLoC principles', 8, 2, 4, '🔄', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch8-l1'), cq_id('dart-ch8'), 'dart', 'InheritedWidget & Provider', 'Passing state down the widget tree', 'theory', 'advanced', 1, 80, 20, $content$# InheritedWidget & Provider\n\n## Overview\nPassing state down the widget tree.\n\n```\n// Example code for InheritedWidget & Provider\n```$content$, ARRAY['dart', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch8-l2'), cq_id('dart-ch8'), 'dart', 'Reactive State Notifiers', 'ChangeNotifier and ValueNotifier patterns', 'theory', 'advanced', 2, 80, 20, $content$# Reactive State Notifiers\n\n## Overview\nChangeNotifier and ValueNotifier patterns.\n\n```\n// Example code for Reactive State Notifiers\n```$content$, ARRAY['dart', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch8-l3'), cq_id('dart-ch8'), 'dart', 'State Management Quiz', 'Verify your state management knowledge', 'quiz', 'advanced', 3, 80, 20, $content$# State Management Quiz\n\n## Overview\nVerify your state management knowledge.\n\n```\n// Example code for State Management Quiz\n```$content$, ARRAY['dart', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch8-l3-1'), cq_id('dart-ch8-l3'), 'Question 1: State Management Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for State Management Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch8-l3-2'), cq_id('dart-ch8-l3'), 'Question 2: State Management Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for State Management Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch8-l3-3'), cq_id('dart-ch8-l3'), 'Question 3: State Management Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for State Management Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch8-l3-4'), cq_id('dart-ch8-l3'), 'Question 4: State Management Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for State Management Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch8-l4'), cq_id('dart-ch8'), 'dart', 'Simple State Store', 'Implement an observer-based state container', 'coding', 'advanced', 4, 80, 20, $content$# Simple State Store\n\n## Overview\nImplement an observer-based state container.\n\n```\n// Example code for Simple State Store\n```$content$, ARRAY['dart', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-dart-ch8-l4'), cq_id('dart-ch8-l4'), 'dart', 'Simple State Store', 'Implement an observer-based state container', '// Starter code for Simple State Store in dart', '// Solution code for Simple State Store in dart', '["Review the theory", "Check edge cases"]'::jsonb, 'advanced', 120, 35, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('dart-ch9'), 'dart', 'Advanced Dart & Isolates', 'Concurrency with Isolates and extensions', 9, 2, 4, '🚀', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch9-l1'), cq_id('dart-ch9'), 'dart', 'Isolates & Threading', 'True multi-threading without shared memory', 'theory', 'advanced', 1, 80, 20, $content$# Isolates & Threading\n\n## Overview\nTrue multi-threading without shared memory.\n\n```\n// Example code for Isolates & Threading\n```$content$, ARRAY['dart', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch9-l2'), cq_id('dart-ch9'), 'dart', 'Extension Methods', 'Add custom methods to existing classes', 'theory', 'advanced', 2, 80, 20, $content$# Extension Methods\n\n## Overview\nAdd custom methods to existing classes.\n\n```\n// Example code for Extension Methods\n```$content$, ARRAY['dart', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch9-l3'), cq_id('dart-ch9'), 'dart', 'Advanced Dart Quiz', 'Test your deep Dart runtime knowledge', 'quiz', 'advanced', 3, 80, 20, $content$# Advanced Dart Quiz\n\n## Overview\nTest your deep Dart runtime knowledge.\n\n```\n// Example code for Advanced Dart Quiz\n```$content$, ARRAY['dart', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch9-l3-1'), cq_id('dart-ch9-l3'), 'Question 1: Advanced Dart Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Advanced Dart Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch9-l3-2'), cq_id('dart-ch9-l3'), 'Question 2: Advanced Dart Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Advanced Dart Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch9-l3-3'), cq_id('dart-ch9-l3'), 'Question 3: Advanced Dart Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Advanced Dart Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch9-l3-4'), cq_id('dart-ch9-l3'), 'Question 4: Advanced Dart Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Advanced Dart Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('dart-ch9-l4'), cq_id('dart-ch9'), 'dart', 'Boss Battle: The Isolate Titan', 'Overcome CPU-bound challenges with Isolates!', 'boss_battle', 'expert', 4, 200, 50, $content$# Boss Battle: The Isolate Titan\n\n## Overview\nOvercome CPU-bound challenges with Isolates!.\n\n```\n// Example code for Boss Battle: The Isolate Titan\n```$content$, ARRAY['dart', 'boss_battle'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch9-l4-1'), cq_id('dart-ch9-l4'), 'Question 1: Boss Battle: The Isolate Titan', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Boss Battle: The Isolate Titan', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch9-l4-2'), cq_id('dart-ch9-l4'), 'Question 2: Boss Battle: The Isolate Titan', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Boss Battle: The Isolate Titan', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch9-l4-3'), cq_id('dart-ch9-l4'), 'Question 3: Boss Battle: The Isolate Titan', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Boss Battle: The Isolate Titan', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-dart-ch9-l4-4'), cq_id('dart-ch9-l4'), 'Question 4: Boss Battle: The Isolate Titan', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Boss Battle: The Isolate Titan', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;

-- ── JAVA Level 2 & 3 Chapters ──
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('java-ch4'), 'java', 'OOP Foundations', 'Encapsulation, constructors, and getters/setters', 4, 1, 4, '🏗️', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch4-l1'), cq_id('java-ch4'), 'java', 'Classes, Fields & Methods', 'Blueprint domain entities in Java', 'theory', 'intermediate', 1, 60, 15, $content$# Classes, Fields & Methods\n\n## Overview\nBlueprint domain entities in Java.\n\n```\n// Example code for Classes, Fields & Methods\n```$content$, ARRAY['java', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch4-l2'), cq_id('java-ch4'), 'java', 'Constructors & Overloading', 'Initialize objects with constructor overloading', 'theory', 'intermediate', 2, 60, 15, $content$# Constructors & Overloading\n\n## Overview\nInitialize objects with constructor overloading.\n\n```\n// Example code for Constructors & Overloading\n```$content$, ARRAY['java', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch4-l3'), cq_id('java-ch4'), 'java', 'OOP Foundations Quiz', 'Test basic Java object-oriented principles', 'quiz', 'intermediate', 3, 60, 15, $content$# OOP Foundations Quiz\n\n## Overview\nTest basic Java object-oriented principles.\n\n```\n// Example code for OOP Foundations Quiz\n```$content$, ARRAY['java', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch4-l3-1'), cq_id('java-ch4-l3'), 'Question 1: OOP Foundations Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for OOP Foundations Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch4-l3-2'), cq_id('java-ch4-l3'), 'Question 2: OOP Foundations Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for OOP Foundations Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch4-l3-3'), cq_id('java-ch4-l3'), 'Question 3: OOP Foundations Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for OOP Foundations Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch4-l3-4'), cq_id('java-ch4-l3'), 'Question 4: OOP Foundations Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for OOP Foundations Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch4-l4'), cq_id('java-ch4'), 'java', 'Bank Account Model', 'Encapsulated account with deposit/withdraw', 'coding', 'intermediate', 4, 60, 15, $content$# Bank Account Model\n\n## Overview\nEncapsulated account with deposit/withdraw.\n\n```\n// Example code for Bank Account Model\n```$content$, ARRAY['java', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-java-ch4-l4'), cq_id('java-ch4-l4'), 'java', 'Bank Account Model', 'Encapsulated account with deposit/withdraw', '// Starter code for Bank Account Model in java', '// Solution code for Bank Account Model in java', '["Review the theory", "Check edge cases"]'::jsonb, 'intermediate', 100, 30, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('java-ch5'), 'java', 'Inheritance & Polymorphism', 'Abstract classes, interfaces, and @Override', 5, 1, 4, '🧬', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch5-l1'), cq_id('java-ch5'), 'java', 'Inheritance & ''super''', 'Extend classes and call parent constructors', 'theory', 'intermediate', 1, 60, 15, $content$# Inheritance & 'super'\n\n## Overview\nExtend classes and call parent constructors.\n\n```\n// Example code for Inheritance & 'super'\n```$content$, ARRAY['java', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch5-l2'), cq_id('java-ch5'), 'java', 'Interfaces & Polymorphism', 'Contract-based design with multiple interfaces', 'theory', 'intermediate', 2, 60, 15, $content$# Interfaces & Polymorphism\n\n## Overview\nContract-based design with multiple interfaces.\n\n```\n// Example code for Interfaces & Polymorphism\n```$content$, ARRAY['java', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch5-l3'), cq_id('java-ch5'), 'java', 'Polymorphism Quiz', 'Test dynamic method dispatch in Java', 'quiz', 'intermediate', 3, 60, 15, $content$# Polymorphism Quiz\n\n## Overview\nTest dynamic method dispatch in Java.\n\n```\n// Example code for Polymorphism Quiz\n```$content$, ARRAY['java', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch5-l3-1'), cq_id('java-ch5-l3'), 'Question 1: Polymorphism Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Polymorphism Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch5-l3-2'), cq_id('java-ch5-l3'), 'Question 2: Polymorphism Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Polymorphism Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch5-l3-3'), cq_id('java-ch5-l3'), 'Question 3: Polymorphism Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Polymorphism Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch5-l3-4'), cq_id('java-ch5-l3'), 'Question 4: Polymorphism Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Polymorphism Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch5-l4'), cq_id('java-ch5'), 'java', 'Shape Area Calculator', 'Polymorphic area calculations for shapes', 'coding', 'intermediate', 4, 60, 15, $content$# Shape Area Calculator\n\n## Overview\nPolymorphic area calculations for shapes.\n\n```\n// Example code for Shape Area Calculator\n```$content$, ARRAY['java', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-java-ch5-l4'), cq_id('java-ch5-l4'), 'java', 'Shape Area Calculator', 'Polymorphic area calculations for shapes', '// Starter code for Shape Area Calculator in java', '// Solution code for Shape Area Calculator in java', '["Review the theory", "Check edge cases"]'::jsonb, 'intermediate', 100, 30, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('java-ch6'), 'java', 'Collections Framework', 'ArrayList, HashMap, HashSet, and Iterators', 6, 1, 4, '📦', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch6-l1'), cq_id('java-ch6'), 'java', 'List & Set Implementations', 'ArrayList, LinkedList, and HashSet', 'theory', 'intermediate', 1, 60, 15, $content$# List & Set Implementations\n\n## Overview\nArrayList, LinkedList, and HashSet.\n\n```\n// Example code for List & Set Implementations\n```$content$, ARRAY['java', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch6-l2'), cq_id('java-ch6'), 'java', 'HashMap & TreeMap', 'Fast key-value storage and sorting', 'theory', 'intermediate', 2, 60, 15, $content$# HashMap & TreeMap\n\n## Overview\nFast key-value storage and sorting.\n\n```\n// Example code for HashMap & TreeMap\n```$content$, ARRAY['java', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch6-l3'), cq_id('java-ch6'), 'java', 'Collections Quiz', 'Choose the right data structure for the job', 'quiz', 'intermediate', 3, 60, 15, $content$# Collections Quiz\n\n## Overview\nChoose the right data structure for the job.\n\n```\n// Example code for Collections Quiz\n```$content$, ARRAY['java', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch6-l3-1'), cq_id('java-ch6-l3'), 'Question 1: Collections Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Collections Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch6-l3-2'), cq_id('java-ch6-l3'), 'Question 2: Collections Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Collections Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch6-l3-3'), cq_id('java-ch6-l3'), 'Question 3: Collections Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Collections Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch6-l3-4'), cq_id('java-ch6-l3'), 'Question 4: Collections Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Collections Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch6-l4'), cq_id('java-ch6'), 'java', 'Frequency Counter Java', 'Count word frequencies using HashMap', 'coding', 'intermediate', 4, 60, 15, $content$# Frequency Counter Java\n\n## Overview\nCount word frequencies using HashMap.\n\n```\n// Example code for Frequency Counter Java\n```$content$, ARRAY['java', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-java-ch6-l4'), cq_id('java-ch6-l4'), 'java', 'Frequency Counter Java', 'Count word frequencies using HashMap', '// Starter code for Frequency Counter Java in java', '// Solution code for Frequency Counter Java in java', '["Review the theory", "Check edge cases"]'::jsonb, 'intermediate', 100, 30, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('java-ch7'), 'java', 'Exception Engineering', 'Checked vs unchecked exceptions and try-with-resources', 7, 2, 4, '🛡️', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch7-l1'), cq_id('java-ch7'), 'java', 'Exception Hierarchy', 'Throwable, Exception, RuntimeException', 'theory', 'advanced', 1, 80, 20, $content$# Exception Hierarchy\n\n## Overview\nThrowable, Exception, RuntimeException.\n\n```\n// Example code for Exception Hierarchy\n```$content$, ARRAY['java', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch7-l2'), cq_id('java-ch7'), 'java', 'Try-With-Resources & AutoCloseable', 'Safe automatic resource closing', 'theory', 'advanced', 2, 80, 20, $content$# Try-With-Resources & AutoCloseable\n\n## Overview\nSafe automatic resource closing.\n\n```\n// Example code for Try-With-Resources & AutoCloseable\n```$content$, ARRAY['java', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch7-l3'), cq_id('java-ch7'), 'java', 'Exceptions Quiz', 'Master defensive error handling in Java', 'quiz', 'advanced', 3, 80, 20, $content$# Exceptions Quiz\n\n## Overview\nMaster defensive error handling in Java.\n\n```\n// Example code for Exceptions Quiz\n```$content$, ARRAY['java', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch7-l3-1'), cq_id('java-ch7-l3'), 'Question 1: Exceptions Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Exceptions Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch7-l3-2'), cq_id('java-ch7-l3'), 'Question 2: Exceptions Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Exceptions Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch7-l3-3'), cq_id('java-ch7-l3'), 'Question 3: Exceptions Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Exceptions Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch7-l3-4'), cq_id('java-ch7-l3'), 'Question 4: Exceptions Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Exceptions Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch7-l4'), cq_id('java-ch7'), 'java', 'Safe File Parser', 'Safely read numbers from text with fallback', 'coding', 'advanced', 4, 80, 20, $content$# Safe File Parser\n\n## Overview\nSafely read numbers from text with fallback.\n\n```\n// Example code for Safe File Parser\n```$content$, ARRAY['java', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-java-ch7-l4'), cq_id('java-ch7-l4'), 'java', 'Safe File Parser', 'Safely read numbers from text with fallback', '// Starter code for Safe File Parser in java', '// Solution code for Safe File Parser in java', '["Review the theory", "Check edge cases"]'::jsonb, 'advanced', 120, 35, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('java-ch8'), 'java', 'Generics & Lambdas', 'Type parameters, wildcards, and functional interfaces', 8, 2, 4, '🔬', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch8-l1'), cq_id('java-ch8'), 'java', 'Generic Classes & Methods', 'Type-safe container creation with <T>', 'theory', 'advanced', 1, 80, 20, $content$# Generic Classes & Methods\n\n## Overview\nType-safe container creation with <T>.\n\n```\n// Example code for Generic Classes & Methods\n```$content$, ARRAY['java', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch8-l2'), cq_id('java-ch8'), 'java', 'Lambda Expressions & Method Refs', 'Functional programming with java.util.function', 'theory', 'advanced', 2, 80, 20, $content$# Lambda Expressions & Method Refs\n\n## Overview\nFunctional programming with java.util.function.\n\n```\n// Example code for Lambda Expressions & Method Refs\n```$content$, ARRAY['java', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch8-l3'), cq_id('java-ch8'), 'java', 'Generics Quiz', 'Understand type erasure and covariance', 'quiz', 'advanced', 3, 80, 20, $content$# Generics Quiz\n\n## Overview\nUnderstand type erasure and covariance.\n\n```\n// Example code for Generics Quiz\n```$content$, ARRAY['java', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch8-l3-1'), cq_id('java-ch8-l3'), 'Question 1: Generics Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Generics Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch8-l3-2'), cq_id('java-ch8-l3'), 'Question 2: Generics Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Generics Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch8-l3-3'), cq_id('java-ch8-l3'), 'Question 3: Generics Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Generics Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch8-l3-4'), cq_id('java-ch8-l3'), 'Question 4: Generics Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Generics Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch8-l4'), cq_id('java-ch8'), 'java', 'Generic Stack Implementation', 'Implement a type-safe generic stack', 'coding', 'advanced', 4, 80, 20, $content$# Generic Stack Implementation\n\n## Overview\nImplement a type-safe generic stack.\n\n```\n// Example code for Generic Stack Implementation\n```$content$, ARRAY['java', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-java-ch8-l4'), cq_id('java-ch8-l4'), 'java', 'Generic Stack Implementation', 'Implement a type-safe generic stack', '// Starter code for Generic Stack Implementation in java', '// Solution code for Generic Stack Implementation in java', '["Review the theory", "Check edge cases"]'::jsonb, 'advanced', 120, 35, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('java-ch9'), 'java', 'Streams & Concurrency', 'Stream API, threads, and ExecutorService', 9, 2, 4, '⚡', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch9-l1'), cq_id('java-ch9'), 'java', 'The Stream API', 'Filter, map, reduce, and parallel streams', 'theory', 'advanced', 1, 80, 20, $content$# The Stream API\n\n## Overview\nFilter, map, reduce, and parallel streams.\n\n```\n// Example code for The Stream API\n```$content$, ARRAY['java', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch9-l2'), cq_id('java-ch9'), 'java', 'Multithreading & Executors', 'Thread pools and asynchronous Future tasks', 'theory', 'advanced', 2, 80, 20, $content$# Multithreading & Executors\n\n## Overview\nThread pools and asynchronous Future tasks.\n\n```\n// Example code for Multithreading & Executors\n```$content$, ARRAY['java', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch9-l3'), cq_id('java-ch9'), 'java', 'Concurrency Quiz', 'Test thread safety and synchronization', 'quiz', 'advanced', 3, 80, 20, $content$# Concurrency Quiz\n\n## Overview\nTest thread safety and synchronization.\n\n```\n// Example code for Concurrency Quiz\n```$content$, ARRAY['java', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch9-l3-1'), cq_id('java-ch9-l3'), 'Question 1: Concurrency Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Concurrency Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch9-l3-2'), cq_id('java-ch9-l3'), 'Question 2: Concurrency Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Concurrency Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch9-l3-3'), cq_id('java-ch9-l3'), 'Question 3: Concurrency Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Concurrency Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch9-l3-4'), cq_id('java-ch9-l3'), 'Question 4: Concurrency Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Concurrency Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('java-ch9-l4'), cq_id('java-ch9'), 'java', 'Boss Battle: The JVM Sovereign', 'Tame memory, threads, and streams!', 'boss_battle', 'expert', 4, 200, 50, $content$# Boss Battle: The JVM Sovereign\n\n## Overview\nTame memory, threads, and streams!.\n\n```\n// Example code for Boss Battle: The JVM Sovereign\n```$content$, ARRAY['java', 'boss_battle'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch9-l4-1'), cq_id('java-ch9-l4'), 'Question 1: Boss Battle: The JVM Sovereign', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Boss Battle: The JVM Sovereign', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch9-l4-2'), cq_id('java-ch9-l4'), 'Question 2: Boss Battle: The JVM Sovereign', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Boss Battle: The JVM Sovereign', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch9-l4-3'), cq_id('java-ch9-l4'), 'Question 3: Boss Battle: The JVM Sovereign', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Boss Battle: The JVM Sovereign', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-java-ch9-l4-4'), cq_id('java-ch9-l4'), 'Question 4: Boss Battle: The JVM Sovereign', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Boss Battle: The JVM Sovereign', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;

-- ── CPP Level 2 & 3 Chapters ──
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('cpp-ch4'), 'cpp', 'OOP in C++', 'Constructors, destructors, RAII, and inheritance', 4, 1, 4, '🏗️', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch4-l1'), cq_id('cpp-ch4'), 'cpp', 'Classes, Members & Access', 'public, private, protected in C++', 'theory', 'intermediate', 1, 60, 15, $content$# Classes, Members & Access\n\n## Overview\npublic, private, protected in C++.\n\n```\n// Example code for Classes, Members & Access\n```$content$, ARRAY['cpp', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch4-l2'), cq_id('cpp-ch4'), 'cpp', 'RAII & Destructors', 'Resource Acquisition Is Initialization', 'theory', 'intermediate', 2, 60, 15, $content$# RAII & Destructors\n\n## Overview\nResource Acquisition Is Initialization.\n\n```\n// Example code for RAII & Destructors\n```$content$, ARRAY['cpp', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch4-l3'), cq_id('cpp-ch4'), 'cpp', 'C++ OOP Quiz', 'Test member initialization and destruction', 'quiz', 'intermediate', 3, 60, 15, $content$# C++ OOP Quiz\n\n## Overview\nTest member initialization and destruction.\n\n```\n// Example code for C++ OOP Quiz\n```$content$, ARRAY['cpp', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch4-l3-1'), cq_id('cpp-ch4-l3'), 'Question 1: C++ OOP Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for C++ OOP Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch4-l3-2'), cq_id('cpp-ch4-l3'), 'Question 2: C++ OOP Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for C++ OOP Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch4-l3-3'), cq_id('cpp-ch4-l3'), 'Question 3: C++ OOP Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for C++ OOP Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch4-l3-4'), cq_id('cpp-ch4-l3'), 'Question 4: C++ OOP Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for C++ OOP Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch4-l4'), cq_id('cpp-ch4'), 'cpp', 'Scoped Buffer Class', 'Implement an RAII heap buffer class', 'coding', 'intermediate', 4, 60, 15, $content$# Scoped Buffer Class\n\n## Overview\nImplement an RAII heap buffer class.\n\n```\n// Example code for Scoped Buffer Class\n```$content$, ARRAY['cpp', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-cpp-ch4-l4'), cq_id('cpp-ch4-l4'), 'cpp', 'Scoped Buffer Class', 'Implement an RAII heap buffer class', '// Starter code for Scoped Buffer Class in cpp', '// Solution code for Scoped Buffer Class in cpp', '["Review the theory", "Check edge cases"]'::jsonb, 'intermediate', 100, 30, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('cpp-ch5'), 'cpp', 'Pointers & Dynamic Memory', 'Heap allocation, references, and pointer arithmetic', 5, 1, 4, '🧠', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch5-l1'), cq_id('cpp-ch5'), 'cpp', 'Pointers vs References', 'Addresses, dereferencing, and aliases', 'theory', 'intermediate', 1, 60, 15, $content$# Pointers vs References\n\n## Overview\nAddresses, dereferencing, and aliases.\n\n```\n// Example code for Pointers vs References\n```$content$, ARRAY['cpp', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch5-l2'), cq_id('cpp-ch5'), 'cpp', 'Dynamic Memory with new & delete', 'Heap management and memory leak prevention', 'theory', 'intermediate', 2, 60, 15, $content$# Dynamic Memory with new & delete\n\n## Overview\nHeap management and memory leak prevention.\n\n```\n// Example code for Dynamic Memory with new & delete\n```$content$, ARRAY['cpp', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch5-l3'), cq_id('cpp-ch5'), 'cpp', 'Memory Quiz', 'Avoid dangling pointers and double frees', 'quiz', 'intermediate', 3, 60, 15, $content$# Memory Quiz\n\n## Overview\nAvoid dangling pointers and double frees.\n\n```\n// Example code for Memory Quiz\n```$content$, ARRAY['cpp', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch5-l3-1'), cq_id('cpp-ch5-l3'), 'Question 1: Memory Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Memory Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch5-l3-2'), cq_id('cpp-ch5-l3'), 'Question 2: Memory Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Memory Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch5-l3-3'), cq_id('cpp-ch5-l3'), 'Question 3: Memory Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Memory Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch5-l3-4'), cq_id('cpp-ch5-l3'), 'Question 4: Memory Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Memory Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch5-l4'), cq_id('cpp-ch5'), 'cpp', 'Dynamic Array Reverser', 'Reverse heap-allocated arrays using pointers', 'coding', 'intermediate', 4, 60, 15, $content$# Dynamic Array Reverser\n\n## Overview\nReverse heap-allocated arrays using pointers.\n\n```\n// Example code for Dynamic Array Reverser\n```$content$, ARRAY['cpp', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-cpp-ch5-l4'), cq_id('cpp-ch5-l4'), 'cpp', 'Dynamic Array Reverser', 'Reverse heap-allocated arrays using pointers', '// Starter code for Dynamic Array Reverser in cpp', '// Solution code for Dynamic Array Reverser in cpp', '["Review the theory", "Check edge cases"]'::jsonb, 'intermediate', 100, 30, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('cpp-ch6'), 'cpp', 'STL Containers', 'std::vector, std::map, std::set, and iterators', 6, 1, 4, '📦', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch6-l1'), cq_id('cpp-ch6'), 'cpp', 'Vector & Sequence Containers', 'Dynamic array resizing, capacity, and iterators', 'theory', 'intermediate', 1, 60, 15, $content$# Vector & Sequence Containers\n\n## Overview\nDynamic array resizing, capacity, and iterators.\n\n```\n// Example code for Vector & Sequence Containers\n```$content$, ARRAY['cpp', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch6-l2'), cq_id('cpp-ch6'), 'cpp', 'Associative Containers', 'map, unordered_map, and set complexity', 'theory', 'intermediate', 2, 60, 15, $content$# Associative Containers\n\n## Overview\nmap, unordered_map, and set complexity.\n\n```\n// Example code for Associative Containers\n```$content$, ARRAY['cpp', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch6-l3'), cq_id('cpp-ch6'), 'cpp', 'STL Quiz', 'Select the optimal STL container', 'quiz', 'intermediate', 3, 60, 15, $content$# STL Quiz\n\n## Overview\nSelect the optimal STL container.\n\n```\n// Example code for STL Quiz\n```$content$, ARRAY['cpp', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch6-l3-1'), cq_id('cpp-ch6-l3'), 'Question 1: STL Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for STL Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch6-l3-2'), cq_id('cpp-ch6-l3'), 'Question 2: STL Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for STL Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch6-l3-3'), cq_id('cpp-ch6-l3'), 'Question 3: STL Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for STL Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch6-l3-4'), cq_id('cpp-ch6-l3'), 'Question 4: STL Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for STL Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch6-l4'), cq_id('cpp-ch6'), 'cpp', 'Two Sum with Map', 'O(n) two sum solution with std::unordered_map', 'coding', 'intermediate', 4, 60, 15, $content$# Two Sum with Map\n\n## Overview\nO(n) two sum solution with std::unordered_map.\n\n```\n// Example code for Two Sum with Map\n```$content$, ARRAY['cpp', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-cpp-ch6-l4'), cq_id('cpp-ch6-l4'), 'cpp', 'Two Sum with Map', 'O(n) two sum solution with std::unordered_map', '// Starter code for Two Sum with Map in cpp', '// Solution code for Two Sum with Map in cpp', '["Review the theory", "Check edge cases"]'::jsonb, 'intermediate', 100, 30, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('cpp-ch7'), 'cpp', 'Templates & Generics', 'Function templates, class templates, and traits', 7, 2, 4, '🔬', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch7-l1'), cq_id('cpp-ch7'), 'cpp', 'Function & Class Templates', 'Writing type-agnostic algorithms with template<typename T>', 'theory', 'advanced', 1, 80, 20, $content$# Function & Class Templates\n\n## Overview\nWriting type-agnostic algorithms with template<typename T>.\n\n```\n// Example code for Function & Class Templates\n```$content$, ARRAY['cpp', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch7-l2'), cq_id('cpp-ch7'), 'cpp', 'Template Specialization', 'Custom implementations for specific types', 'theory', 'advanced', 2, 80, 20, $content$# Template Specialization\n\n## Overview\nCustom implementations for specific types.\n\n```\n// Example code for Template Specialization\n```$content$, ARRAY['cpp', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch7-l3'), cq_id('cpp-ch7'), 'cpp', 'Templates Quiz', 'Test compile-time generic programming', 'quiz', 'advanced', 3, 80, 20, $content$# Templates Quiz\n\n## Overview\nTest compile-time generic programming.\n\n```\n// Example code for Templates Quiz\n```$content$, ARRAY['cpp', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch7-l3-1'), cq_id('cpp-ch7-l3'), 'Question 1: Templates Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Templates Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch7-l3-2'), cq_id('cpp-ch7-l3'), 'Question 2: Templates Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Templates Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch7-l3-3'), cq_id('cpp-ch7-l3'), 'Question 3: Templates Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Templates Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch7-l3-4'), cq_id('cpp-ch7-l3'), 'Question 4: Templates Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Templates Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch7-l4'), cq_id('cpp-ch7'), 'cpp', 'Generic Stack Template', 'Build a generic template-based stack class', 'coding', 'advanced', 4, 80, 20, $content$# Generic Stack Template\n\n## Overview\nBuild a generic template-based stack class.\n\n```\n// Example code for Generic Stack Template\n```$content$, ARRAY['cpp', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-cpp-ch7-l4'), cq_id('cpp-ch7-l4'), 'cpp', 'Generic Stack Template', 'Build a generic template-based stack class', '// Starter code for Generic Stack Template in cpp', '// Solution code for Generic Stack Template in cpp', '["Review the theory", "Check edge cases"]'::jsonb, 'advanced', 120, 35, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('cpp-ch8'), 'cpp', 'Move Semantics & Smart Pointers', 'rvalue references, std::move, unique_ptr, shared_ptr', 8, 2, 4, '🚀', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch8-l1'), cq_id('cpp-ch8'), 'cpp', 'Move Semantics & Rule of Five', 'Efficient transfer of heavy heap resources', 'theory', 'advanced', 1, 80, 20, $content$# Move Semantics & Rule of Five\n\n## Overview\nEfficient transfer of heavy heap resources.\n\n```\n// Example code for Move Semantics & Rule of Five\n```$content$, ARRAY['cpp', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch8-l2'), cq_id('cpp-ch8'), 'cpp', 'Smart Pointers in C++11', 'std::unique_ptr and std::shared_ptr safety', 'theory', 'advanced', 2, 80, 20, $content$# Smart Pointers in C++11\n\n## Overview\nstd::unique_ptr and std::shared_ptr safety.\n\n```\n// Example code for Smart Pointers in C++11\n```$content$, ARRAY['cpp', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch8-l3'), cq_id('cpp-ch8'), 'cpp', 'Smart Pointers Quiz', 'Master modern modern C++ memory ownership', 'quiz', 'advanced', 3, 80, 20, $content$# Smart Pointers Quiz\n\n## Overview\nMaster modern modern C++ memory ownership.\n\n```\n// Example code for Smart Pointers Quiz\n```$content$, ARRAY['cpp', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch8-l3-1'), cq_id('cpp-ch8-l3'), 'Question 1: Smart Pointers Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Smart Pointers Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch8-l3-2'), cq_id('cpp-ch8-l3'), 'Question 2: Smart Pointers Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Smart Pointers Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch8-l3-3'), cq_id('cpp-ch8-l3'), 'Question 3: Smart Pointers Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Smart Pointers Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch8-l3-4'), cq_id('cpp-ch8-l3'), 'Question 4: Smart Pointers Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Smart Pointers Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch8-l4'), cq_id('cpp-ch8'), 'cpp', 'Safe Resource Manager', 'Manage resources safely using std::unique_ptr', 'coding', 'advanced', 4, 80, 20, $content$# Safe Resource Manager\n\n## Overview\nManage resources safely using std::unique_ptr.\n\n```\n// Example code for Safe Resource Manager\n```$content$, ARRAY['cpp', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-cpp-ch8-l4'), cq_id('cpp-ch8-l4'), 'cpp', 'Safe Resource Manager', 'Manage resources safely using std::unique_ptr', '// Starter code for Safe Resource Manager in cpp', '// Solution code for Safe Resource Manager in cpp', '["Review the theory", "Check edge cases"]'::jsonb, 'advanced', 120, 35, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('cpp-ch9'), 'cpp', 'Concurrency in C++', 'std::thread, std::mutex, and async tasks', 9, 2, 4, '⚡', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch9-l1'), cq_id('cpp-ch9'), 'cpp', 'Threads & Mutexes', 'Spawning threads and locking shared state', 'theory', 'advanced', 1, 80, 20, $content$# Threads & Mutexes\n\n## Overview\nSpawning threads and locking shared state.\n\n```\n// Example code for Threads & Mutexes\n```$content$, ARRAY['cpp', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch9-l2'), cq_id('cpp-ch9'), 'cpp', 'std::future & std::async', 'Asynchronous task execution and value retrieval', 'theory', 'advanced', 2, 80, 20, $content$# std::future & std::async\n\n## Overview\nAsynchronous task execution and value retrieval.\n\n```\n// Example code for std::future & std::async\n```$content$, ARRAY['cpp', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch9-l3'), cq_id('cpp-ch9'), 'cpp', 'Concurrency Quiz', 'Prevent deadlocks and race conditions', 'quiz', 'advanced', 3, 80, 20, $content$# Concurrency Quiz\n\n## Overview\nPrevent deadlocks and race conditions.\n\n```\n// Example code for Concurrency Quiz\n```$content$, ARRAY['cpp', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch9-l3-1'), cq_id('cpp-ch9-l3'), 'Question 1: Concurrency Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Concurrency Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch9-l3-2'), cq_id('cpp-ch9-l3'), 'Question 2: Concurrency Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Concurrency Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch9-l3-3'), cq_id('cpp-ch9-l3'), 'Question 3: Concurrency Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Concurrency Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch9-l3-4'), cq_id('cpp-ch9-l3'), 'Question 4: Concurrency Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Concurrency Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('cpp-ch9-l4'), cq_id('cpp-ch9'), 'cpp', 'Boss Battle: The Concurrency Colossus', 'Conquer multi-threaded race conditions!', 'boss_battle', 'expert', 4, 200, 50, $content$# Boss Battle: The Concurrency Colossus\n\n## Overview\nConquer multi-threaded race conditions!.\n\n```\n// Example code for Boss Battle: The Concurrency Colossus\n```$content$, ARRAY['cpp', 'boss_battle'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch9-l4-1'), cq_id('cpp-ch9-l4'), 'Question 1: Boss Battle: The Concurrency Colossus', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Boss Battle: The Concurrency Colossus', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch9-l4-2'), cq_id('cpp-ch9-l4'), 'Question 2: Boss Battle: The Concurrency Colossus', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Boss Battle: The Concurrency Colossus', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch9-l4-3'), cq_id('cpp-ch9-l4'), 'Question 3: Boss Battle: The Concurrency Colossus', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Boss Battle: The Concurrency Colossus', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-cpp-ch9-l4-4'), cq_id('cpp-ch9-l4'), 'Question 4: Boss Battle: The Concurrency Colossus', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Boss Battle: The Concurrency Colossus', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;

-- ── C Level 2 & 3 Chapters ──
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('c-ch4'), 'c', 'Pointers & Memory Addresses', 'Address-of operator, dereferencing, and pointer math', 4, 1, 4, '🧠', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch4-l1'), cq_id('c-ch4'), 'c', 'Pointer Fundamentals', 'Variables storing memory addresses', 'theory', 'intermediate', 1, 60, 15, $content$# Pointer Fundamentals\n\n## Overview\nVariables storing memory addresses.\n\n```\n// Example code for Pointer Fundamentals\n```$content$, ARRAY['c', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch4-l2'), cq_id('c-ch4'), 'c', 'Pointer Arithmetic', 'Traversing memory arrays using pointer offsets', 'theory', 'intermediate', 2, 60, 15, $content$# Pointer Arithmetic\n\n## Overview\nTraversing memory arrays using pointer offsets.\n\n```\n// Example code for Pointer Arithmetic\n```$content$, ARRAY['c', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch4-l3'), cq_id('c-ch4'), 'c', 'Pointers Quiz', 'Master dereferencing and addresses in C', 'quiz', 'intermediate', 3, 60, 15, $content$# Pointers Quiz\n\n## Overview\nMaster dereferencing and addresses in C.\n\n```\n// Example code for Pointers Quiz\n```$content$, ARRAY['c', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch4-l3-1'), cq_id('c-ch4-l3'), 'Question 1: Pointers Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Pointers Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch4-l3-2'), cq_id('c-ch4-l3'), 'Question 2: Pointers Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Pointers Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch4-l3-3'), cq_id('c-ch4-l3'), 'Question 3: Pointers Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Pointers Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch4-l3-4'), cq_id('c-ch4-l3'), 'Question 4: Pointers Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Pointers Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch4-l4'), cq_id('c-ch4'), 'c', 'Pointer Swap Function', 'Swap two integers using pointers without temp', 'coding', 'intermediate', 4, 60, 15, $content$# Pointer Swap Function\n\n## Overview\nSwap two integers using pointers without temp.\n\n```\n// Example code for Pointer Swap Function\n```$content$, ARRAY['c', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-c-ch4-l4'), cq_id('c-ch4-l4'), 'c', 'Pointer Swap Function', 'Swap two integers using pointers without temp', '// Starter code for Pointer Swap Function in c', '// Solution code for Pointer Swap Function in c', '["Review the theory", "Check edge cases"]'::jsonb, 'intermediate', 100, 30, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('c-ch5'), 'c', 'Arrays & C Strings', 'Character arrays, null terminator, and string.h', 5, 1, 4, '📝', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch5-l1'), cq_id('c-ch5'), 'c', 'C Strings & Null Terminator', 'How strings exist in memory and printf formatting', 'theory', 'intermediate', 1, 60, 15, $content$# C Strings & Null Terminator\n\n## Overview\nHow strings exist in memory and printf formatting.\n\n```\n// Example code for C Strings & Null Terminator\n```$content$, ARRAY['c', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch5-l2'), cq_id('c-ch5'), 'c', 'string.h Library Functions', 'strlen, strcpy, strcat, and strcmp', 'theory', 'intermediate', 2, 60, 15, $content$# string.h Library Functions\n\n## Overview\nstrlen, strcpy, strcat, and strcmp.\n\n```\n// Example code for string.h Library Functions\n```$content$, ARRAY['c', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch5-l3'), cq_id('c-ch5'), 'c', 'C Strings Quiz', 'Avoid buffer overflows and missing terminators', 'quiz', 'intermediate', 3, 60, 15, $content$# C Strings Quiz\n\n## Overview\nAvoid buffer overflows and missing terminators.\n\n```\n// Example code for C Strings Quiz\n```$content$, ARRAY['c', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch5-l3-1'), cq_id('c-ch5-l3'), 'Question 1: C Strings Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for C Strings Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch5-l3-2'), cq_id('c-ch5-l3'), 'Question 2: C Strings Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for C Strings Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch5-l3-3'), cq_id('c-ch5-l3'), 'Question 3: C Strings Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for C Strings Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch5-l3-4'), cq_id('c-ch5-l3'), 'Question 4: C Strings Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for C Strings Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch5-l4'), cq_id('c-ch5'), 'c', 'In-Place String Reverser', 'Reverse a null-terminated string in memory', 'coding', 'intermediate', 4, 60, 15, $content$# In-Place String Reverser\n\n## Overview\nReverse a null-terminated string in memory.\n\n```\n// Example code for In-Place String Reverser\n```$content$, ARRAY['c', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-c-ch5-l4'), cq_id('c-ch5-l4'), 'c', 'In-Place String Reverser', 'Reverse a null-terminated string in memory', '// Starter code for In-Place String Reverser in c', '// Solution code for In-Place String Reverser in c', '["Review the theory", "Check edge cases"]'::jsonb, 'intermediate', 100, 30, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('c-ch6'), 'c', 'Structs & Custom Types', 'Grouping variables, typedef, and struct pointers', 6, 1, 4, '🏗️', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch6-l1'), cq_id('c-ch6'), 'c', 'Defining Structs & typedef', 'Create custom composite data types', 'theory', 'intermediate', 1, 60, 15, $content$# Defining Structs & typedef\n\n## Overview\nCreate custom composite data types.\n\n```\n// Example code for Defining Structs & typedef\n```$content$, ARRAY['c', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch6-l2'), cq_id('c-ch6'), 'c', 'Struct Pointers & Arrow Operator', 'Accessing struct members via pointer ->', 'theory', 'intermediate', 2, 60, 15, $content$# Struct Pointers & Arrow Operator\n\n## Overview\nAccessing struct members via pointer ->.\n\n```\n// Example code for Struct Pointers & Arrow Operator\n```$content$, ARRAY['c', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch6-l3'), cq_id('c-ch6'), 'c', 'Structs Quiz', 'Test your knowledge of memory alignment and structs', 'quiz', 'intermediate', 3, 60, 15, $content$# Structs Quiz\n\n## Overview\nTest your knowledge of memory alignment and structs.\n\n```\n// Example code for Structs Quiz\n```$content$, ARRAY['c', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch6-l3-1'), cq_id('c-ch6-l3'), 'Question 1: Structs Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Structs Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch6-l3-2'), cq_id('c-ch6-l3'), 'Question 2: Structs Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Structs Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch6-l3-3'), cq_id('c-ch6-l3'), 'Question 3: Structs Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Structs Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch6-l3-4'), cq_id('c-ch6-l3'), 'Question 4: Structs Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Structs Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch6-l4'), cq_id('c-ch6'), 'c', 'Student Grade Manager', 'Manage an array of student structs', 'coding', 'intermediate', 4, 60, 15, $content$# Student Grade Manager\n\n## Overview\nManage an array of student structs.\n\n```\n// Example code for Student Grade Manager\n```$content$, ARRAY['c', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-c-ch6-l4'), cq_id('c-ch6-l4'), 'c', 'Student Grade Manager', 'Manage an array of student structs', '// Starter code for Student Grade Manager in c', '// Solution code for Student Grade Manager in c', '["Review the theory", "Check edge cases"]'::jsonb, 'intermediate', 100, 30, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('c-ch7'), 'c', 'Dynamic Memory Allocation', 'malloc, calloc, realloc, and free', 7, 2, 4, '💾', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch7-l1'), cq_id('c-ch7'), 'c', 'Heap Allocation with malloc & free', 'Requesting runtime memory and preventing leaks', 'theory', 'advanced', 1, 80, 20, $content$# Heap Allocation with malloc & free\n\n## Overview\nRequesting runtime memory and preventing leaks.\n\n```\n// Example code for Heap Allocation with malloc & free\n```$content$, ARRAY['c', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch7-l2'), cq_id('c-ch7'), 'c', 'calloc, realloc & Safe Practices', 'Zero-initializing and resizing buffers', 'theory', 'advanced', 2, 80, 20, $content$# calloc, realloc & Safe Practices\n\n## Overview\nZero-initializing and resizing buffers.\n\n```\n// Example code for calloc, realloc & Safe Practices\n```$content$, ARRAY['c', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch7-l3'), cq_id('c-ch7'), 'c', 'Dynamic Memory Quiz', 'Detect memory leaks and double-free bugs', 'quiz', 'advanced', 3, 80, 20, $content$# Dynamic Memory Quiz\n\n## Overview\nDetect memory leaks and double-free bugs.\n\n```\n// Example code for Dynamic Memory Quiz\n```$content$, ARRAY['c', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch7-l3-1'), cq_id('c-ch7-l3'), 'Question 1: Dynamic Memory Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Dynamic Memory Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch7-l3-2'), cq_id('c-ch7-l3'), 'Question 2: Dynamic Memory Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Dynamic Memory Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch7-l3-3'), cq_id('c-ch7-l3'), 'Question 3: Dynamic Memory Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Dynamic Memory Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch7-l3-4'), cq_id('c-ch7-l3'), 'Question 4: Dynamic Memory Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Dynamic Memory Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch7-l4'), cq_id('c-ch7'), 'c', 'Dynamic Integer Array', 'Allocate and resize an integer buffer safely', 'coding', 'advanced', 4, 80, 20, $content$# Dynamic Integer Array\n\n## Overview\nAllocate and resize an integer buffer safely.\n\n```\n// Example code for Dynamic Integer Array\n```$content$, ARRAY['c', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-c-ch7-l4'), cq_id('c-ch7-l4'), 'c', 'Dynamic Integer Array', 'Allocate and resize an integer buffer safely', '// Starter code for Dynamic Integer Array in c', '// Solution code for Dynamic Integer Array in c', '["Review the theory", "Check edge cases"]'::jsonb, 'advanced', 120, 35, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('c-ch8'), 'c', 'File I/O in C', 'fopen, fread, fwrite, fprintf, and binary files', 8, 2, 4, '📂', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch8-l1'), cq_id('c-ch8'), 'c', 'Text File Streams', 'fopen, fgets, fputs, and fclose', 'theory', 'advanced', 1, 80, 20, $content$# Text File Streams\n\n## Overview\nfopen, fgets, fputs, and fclose.\n\n```\n// Example code for Text File Streams\n```$content$, ARRAY['c', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch8-l2'), cq_id('c-ch8'), 'c', 'Binary File I/O', 'Direct memory serialization with fread and fwrite', 'theory', 'advanced', 2, 80, 20, $content$# Binary File I/O\n\n## Overview\nDirect memory serialization with fread and fwrite.\n\n```\n// Example code for Binary File I/O\n```$content$, ARRAY['c', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch8-l3'), cq_id('c-ch8'), 'c', 'File I/O Quiz', 'Test file pointers, modes, and EOF handling', 'quiz', 'advanced', 3, 80, 20, $content$# File I/O Quiz\n\n## Overview\nTest file pointers, modes, and EOF handling.\n\n```\n// Example code for File I/O Quiz\n```$content$, ARRAY['c', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch8-l3-1'), cq_id('c-ch8-l3'), 'Question 1: File I/O Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for File I/O Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch8-l3-2'), cq_id('c-ch8-l3'), 'Question 2: File I/O Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for File I/O Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch8-l3-3'), cq_id('c-ch8-l3'), 'Question 3: File I/O Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for File I/O Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch8-l3-4'), cq_id('c-ch8-l3'), 'Question 4: File I/O Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for File I/O Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch8-l4'), cq_id('c-ch8'), 'c', 'High Score File Saver', 'Write and read score structs to binary files', 'coding', 'advanced', 4, 80, 20, $content$# High Score File Saver\n\n## Overview\nWrite and read score structs to binary files.\n\n```\n// Example code for High Score File Saver\n```$content$, ARRAY['c', 'coding'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO coding_challenges (id, lesson_id, language_id, title, description, starter_code, solution_code, hints, difficulty, xp_reward, coin_reward, is_active)
VALUES (cq_id('cc-c-ch8-l4'), cq_id('c-ch8-l4'), 'c', 'High Score File Saver', 'Write and read score structs to binary files', '// Starter code for High Score File Saver in c', '// Solution code for High Score File Saver in c', '["Review the theory", "Check edge cases"]'::jsonb, 'advanced', 120, 35, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description;
INSERT INTO chapters (id, language_id, title, description, order_index, unlock_requirement, total_lessons, icon_emoji, is_active)
VALUES (cq_id('c-ch9'), 'c', 'Data Structures in C', 'Building linked lists, stacks, and queues from scratch', 9, 2, 4, '📊', true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, unlock_requirement=EXCLUDED.unlock_requirement, total_lessons=EXCLUDED.total_lessons, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch9-l1'), cq_id('c-ch9'), 'c', 'Singly Linked List', 'Node creation, pointer linking, and traversal', 'theory', 'advanced', 1, 80, 20, $content$# Singly Linked List\n\n## Overview\nNode creation, pointer linking, and traversal.\n\n```\n// Example code for Singly Linked List\n```$content$, ARRAY['c', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch9-l2'), cq_id('c-ch9'), 'c', 'Stacks & Queues in C', 'LIFO and FIFO implementations in pure C', 'theory', 'advanced', 2, 80, 20, $content$# Stacks & Queues in C\n\n## Overview\nLIFO and FIFO implementations in pure C.\n\n```\n// Example code for Stacks & Queues in C\n```$content$, ARRAY['c', 'theory'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch9-l3'), cq_id('c-ch9'), 'c', 'Data Structures Quiz', 'Verify pointer manipulation in dynamic lists', 'quiz', 'advanced', 3, 80, 20, $content$# Data Structures Quiz\n\n## Overview\nVerify pointer manipulation in dynamic lists.\n\n```\n// Example code for Data Structures Quiz\n```$content$, ARRAY['c', 'quiz'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch9-l3-1'), cq_id('c-ch9-l3'), 'Question 1: Data Structures Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Data Structures Quiz', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch9-l3-2'), cq_id('c-ch9-l3'), 'Question 2: Data Structures Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Data Structures Quiz', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch9-l3-3'), cq_id('c-ch9-l3'), 'Question 3: Data Structures Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Data Structures Quiz', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch9-l3-4'), cq_id('c-ch9-l3'), 'Question 4: Data Structures Quiz', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Data Structures Quiz', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO lessons (id, chapter_id, language_id, title, description, type, difficulty, order_index, xp_reward, coin_reward, content, tags, estimated_minutes, is_active)
VALUES (cq_id('c-ch9-l4'), cq_id('c-ch9'), 'c', 'Boss Battle: The Segfault Dragon', 'Defeat memory corruption and pointer chaos!', 'boss_battle', 'expert', 4, 200, 50, $content$# Boss Battle: The Segfault Dragon\n\n## Overview\nDefeat memory corruption and pointer chaos!.\n\n```\n// Example code for Boss Battle: The Segfault Dragon\n```$content$, ARRAY['c', 'boss_battle'], 12, true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title, description=EXCLUDED.description, content=EXCLUDED.content, is_active=true;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch9-l4-1'), cq_id('c-ch9-l4'), 'Question 1: Boss Battle: The Segfault Dragon', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Boss Battle: The Segfault Dragon', 1)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch9-l4-2'), cq_id('c-ch9-l4'), 'Question 2: Boss Battle: The Segfault Dragon', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Boss Battle: The Segfault Dragon', 2)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch9-l4-3'), cq_id('c-ch9-l4'), 'Question 3: Boss Battle: The Segfault Dragon', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Boss Battle: The Segfault Dragon', 3)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;
INSERT INTO quiz_questions (id, lesson_id, question, options, correct_option_index, explanation, order_index)
VALUES (cq_id('q-c-ch9-l4-4'), cq_id('c-ch9-l4'), 'Question 4: Boss Battle: The Segfault Dragon', '["Correct Option A", "Incorrect Option B", "Incorrect Option C", "Incorrect Option D"]'::jsonb, 0, 'Explanation for Boss Battle: The Segfault Dragon', 4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question, options=EXCLUDED.options;

-- =============================================================================
-- F. UPDATE TOTAL_LESSONS ON ALL CHAPTERS
-- =============================================================================
UPDATE chapters c
SET total_lessons = (SELECT COUNT(*) FROM lessons l WHERE l.chapter_id = c.id AND l.is_active = true);

-- Done! All lessons, quizzes, coding challenges, and boss battles are seeded.