-- CodeQuest Seed: Python & JavaScript (Part 1)
-- Generated fresh - no ARRAY[] syntax used

INSERT INTO chapters (id,language_id,title,description,order_index,icon_emoji,is_active) VALUES
('10000000-0000-0000-0000-000000000001','python','Python Basics','Variables, data types, and your first Python program',1,'🐍',true),
('10000000-0000-0000-0000-000000000002','python','Control Flow','If statements, loops, and logic',2,'🔀',true),
('10000000-0000-0000-0000-000000000003','python','Functions & Modules','Write reusable code with functions',3,'⚙️',true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,description=EXCLUDED.description,is_active=EXCLUDED.is_active;

INSERT INTO lessons (id,chapter_id,language_id,title,description,type,difficulty,order_index,xp_reward,coin_reward,content,tags,estimated_minutes,is_active) VALUES
('10000001-0000-0000-0000-000000000001','10000000-0000-0000-0000-000000000001','python','Hello, Python!','Write your very first Python program','theory','beginner',1,30,10,'# Hello, Python!

Python is one of the most popular programming languages. Easy to read and great for beginners.

## Your First Program

```python
print("Hello, World!")
```

## Variables

```python
name = "CodeQuest"
age = 25
score = 99.5
is_active = True
```

## Data Types
- **str** -> text: `"hello"`
- **int** -> whole numbers: `42`
- **float** -> decimals: `3.14`
- **bool** -> True or False

## Comments
```python
# This is a comment
print("Comments help explain code")
```','{"python","basics","variables","print"}',8,true),
('10000001-0000-0000-0000-000000000002','10000000-0000-0000-0000-000000000001','python','Variables & Types','Deep dive into Python data types','theory','beginner',2,35,12,'# Variables & Data Types

## String Operations
```python
name = "Alice"
greeting = "Hello, " + name
length = len(name)
upper = name.upper()
```

## Number Operations
```python
x, y = 10, 3
print(x + y)   # 13
print(x // y)  # 3
print(x % y)   # 1
print(x ** y)  # 1000
```

## f-Strings
```python
name = "Gokul"
level = 5
print(f"Player {name} is at level {level}")
```','{"python","variables","types","strings"}',10,true),
('10000001-0000-0000-0000-000000000003','10000000-0000-0000-0000-000000000001','python','Variables Quiz','Test your knowledge of Python basics','quiz','beginner',3,50,20,'# Variables Quiz','{"python","quiz","variables"}',5,true),
('10000001-0000-0000-0000-000000000004','10000000-0000-0000-0000-000000000001','python','Hello World Challenge','Write your first Python program','coding','beginner',4,75,30,'# Coding Challenge: Hello World','{"python","challenge","basics"}',15,true),
('10000001-0000-0000-0000-000000000005','10000000-0000-0000-0000-000000000001','python','Python Basics Boss','Beat the Chapter 1 Boss!','boss_battle','beginner',5,150,60,'# Boss Battle: The Data Type Dragon','{"python","boss","basics"}',20,true),
('10000001-0000-0000-0000-000000000006','10000000-0000-0000-0000-000000000002','python','If Statements','Make decisions in your code','theory','beginner',1,35,12,'# If Statements

```python
score = 85
if score >= 90:
    print("Grade: A")
elif score >= 80:
    print("Grade: B")
else:
    print("Grade: F")
```

## Comparison Operators
- x == y  Equal
- x != y  Not equal
- x >= y  Greater or equal

## Logical Operators
```python
if age >= 18 and has_id:
    print("Entry allowed")
```','{"python","conditionals","if-else"}',10,true),
('10000001-0000-0000-0000-000000000007','10000000-0000-0000-0000-000000000002','python','For & While Loops','Repeat actions with loops','theory','beginner',2,40,15,'# Loops in Python

## For Loop
```python
for i in range(5):
    print(i)

fruits = ["apple","banana","cherry"]
for fruit in fruits:
    print(fruit)
```

## While Loop
```python
count = 0
while count < 5:
    print(count)
    count += 1
```

## Break & Continue
```python
for i in range(10):
    if i == 5: break
    if i % 2 == 0: continue
    print(i)
```','{"python","loops","for","while"}',12,true),
('10000001-0000-0000-0000-000000000008','10000000-0000-0000-0000-000000000002','python','Control Flow Quiz','Test your loop and conditional knowledge','quiz','beginner',3,50,20,'# Control Flow Quiz','{"python","quiz","loops","conditionals"}',5,true),
('10000001-0000-0000-0000-000000000009','10000000-0000-0000-0000-000000000002','python','FizzBuzz Challenge','Classic FizzBuzz problem','coding','beginner',4,80,35,'# FizzBuzz Challenge','{"python","challenge","loops"}',15,true),
('10000001-0000-0000-0000-000000000010','10000000-0000-0000-0000-000000000002','python','Loop Boss Battle','Defeat the Loop Lord!','boss_battle','beginner',5,150,60,'# Boss Battle: The Loop Lord','{"python","boss","loops"}',20,true),
('10000001-0000-0000-0000-000000000011','10000000-0000-0000-0000-000000000003','python','Defining Functions','Create reusable blocks of code','theory','intermediate',1,45,18,'# Functions in Python

```python
def greet(name):
    return f"Hello, {name}!"

print(greet("Gokul"))
```

## Default Parameters
```python
def power(base, exponent=2):
    return base ** exponent

print(power(3))      # 9
print(power(2, 10))  # 1024
```

## Lambda Functions
```python
square = lambda x: x ** 2
names = ["Charlie","Alice","Bob"]
sorted_names = sorted(names, key=lambda x: len(x))
```','{"python","functions","def","lambda"}',12,true),
('10000001-0000-0000-0000-000000000012','10000000-0000-0000-0000-000000000003','python','Lists & Dictionaries','Python data structures','theory','intermediate',2,45,18,'# Lists & Dictionaries

## Lists
```python
numbers = [1, 2, 3, 4, 5]
numbers.append(6)
squares = [x**2 for x in range(10)]
evens = [x for x in range(20) if x % 2 == 0]
```

## Dictionaries
```python
player = {"name":"Gokul","level":5,"xp":1250}
print(player["name"])
print(player.get("rank","Beginner"))
player["level"] = 6
for key, value in player.items():
    print(f"{key}: {value}")
```','{"python","lists","dicts","data-structures"}',14,true),
('10000001-0000-0000-0000-000000000013','10000000-0000-0000-0000-000000000003','python','Functions Quiz','Test your functions knowledge','quiz','intermediate',3,55,22,'# Functions Quiz','{"python","quiz","functions"}',5,true),
('10000001-0000-0000-0000-000000000014','10000000-0000-0000-0000-000000000003','python','Calculator Challenge','Build a working calculator','coding','intermediate',4,100,40,'# Calculator Challenge','{"python","challenge","functions"}',20,true),
('10000001-0000-0000-0000-000000000015','10000000-0000-0000-0000-000000000003','python','Function Master Boss','Final Python Boss!','boss_battle','intermediate',5,200,80,'# Boss Battle: The Function Master','{"python","boss","functions"}',25,true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,content=EXCLUDED.content,is_active=EXCLUDED.is_active;

INSERT INTO quiz_questions (id,lesson_id,question,options,correct_option_index,explanation,code_snippet,order_index) VALUES
('10000002-0000-0000-0000-000000000001','10000001-0000-0000-0000-000000000003','What is the output of print(type(42))?','["<class \"int\">", "<class \"str\">", "<class \"float\">", "<class \"number\">"]',0,'The number 42 is an integer, so type() returns <class "int">',NULL,1),
('10000002-0000-0000-0000-000000000002','10000001-0000-0000-0000-000000000003','Which of these is a valid Python variable name?','["my_var", "2variable", "my-var", "class"]',0,'Variable names must start with a letter or underscore.',NULL,2),
('10000002-0000-0000-0000-000000000003','10000001-0000-0000-0000-000000000003','What does this code print?','["Hello World", "HelloWorld", "Error", "hello world"]',0,'The + operator concatenates strings.','print("Hello " + "World")',3),
('10000002-0000-0000-0000-000000000004','10000001-0000-0000-0000-000000000003','How do you convert the string "42" to an integer?','["int(\"42\")", "integer(\"42\")", "str(42)", "float(\"42\")"]',0,'int() converts a string to an integer.',NULL,4),
('10000002-0000-0000-0000-000000000005','10000001-0000-0000-0000-000000000008','What does this loop print?','["0 1 2 3 4", "1 2 3 4 5", "0 1 2 3 4 5", "1 2 3 4"]',0,'range(5) generates numbers from 0 to 4.','for i in range(5):
    print(i, end='' '')',1),
('10000002-0000-0000-0000-000000000006','10000001-0000-0000-0000-000000000008','Which keyword stops a loop immediately?','["break", "stop", "exit", "continue"]',0,'break exits the loop entirely.',NULL,2),
('10000002-0000-0000-0000-000000000007','10000001-0000-0000-0000-000000000008','What does range(2, 11, 2) print?','["2 4 6 8 10", "1 3 5 7 9", "0 2 4 6 8 10", "1 2 3 4 5"]',0,'range(2, 11, 2) starts at 2, ends before 11, steps by 2.','for i in range(2, 11, 2):
    print(i, end='' '')',3),
('10000002-0000-0000-0000-000000000008','10000001-0000-0000-0000-000000000008','What happens when x=0 in while x<5 if x increments?','["Loop runs 5 times", "Loop runs forever", "Loop never runs", "Error"]',0,'x starts at 0 which is less than 5. The loop runs until x reaches 5.',NULL,4),
('10000002-0000-0000-0000-000000000009','10000001-0000-0000-0000-000000000013','What does add(3, 6) return?','["9", "6", "3", "Error"]',0,'add(3,6) returns 3+6=9.','def add(a, b):
    return a + b
print(add(3, 6))',1),
('10000002-0000-0000-0000-000000000010','10000001-0000-0000-0000-000000000013','What is a default parameter?','["A value used when no argument is provided", "The first parameter", "A required parameter", "A parameter of type int"]',0,'Default parameters have a fallback value.',NULL,2),
('10000002-0000-0000-0000-000000000011','10000001-0000-0000-0000-000000000013','What does this print?','["[1, 4, 9, 16, 25]", "[1, 2, 3, 4, 5]", "[2, 4, 6, 8, 10]", "Error"]',0,'List comprehension creates squares.','result = [x**2 for x in range(1, 6)]
print(result)',3),
('10000002-0000-0000-0000-000000000012','10000001-0000-0000-0000-000000000013','How do you access key "name" in a dict called player?','["player[\"name\"]", "player.name", "player->name", "player(name)"]',0,'Dictionary values are accessed with square brackets: dict[key].',NULL,4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question,options=EXCLUDED.options,correct_option_index=EXCLUDED.correct_option_index;

INSERT INTO coding_challenges (id,lesson_id,title,description,starter_code,solution_code,language_id,hints,time_limit_seconds,memory_limit_mb,is_active) VALUES
('10000003-0000-0000-0000-000000000001','10000001-0000-0000-0000-000000000004','Hello World','Print "Hello, CodeQuest!" to the screen.','# Write your code below
','print("Hello, CodeQuest!")','python','["Use the print() function", "Put the text inside quotes", "Text must match exactly: Hello, CodeQuest!"]',30,64,true),
('10000003-0000-0000-0000-000000000002','10000001-0000-0000-0000-000000000009','FizzBuzz','Print numbers 1-20. Multiples of 3->Fizz, 5->Buzz, both->FizzBuzz.','for i in range(1, 21):
    # Your code here
    pass
','for i in range(1, 21):
    if i % 15 == 0:
        print("FizzBuzz")
    elif i % 3 == 0:
        print("Fizz")
    elif i % 5 == 0:
        print("Buzz")
    else:
        print(i)','python','["Check for 15 (3x5) first", "Use the modulo operator %", "x % 3 == 0 means x is divisible by 3"]',60,64,true),
('10000003-0000-0000-0000-000000000003','10000001-0000-0000-0000-000000000014','Simple Calculator','Create calculate(a, b, op) returning result. Op: +,-,*,/ .','def calculate(a, b, op):
    # Your code here
    pass

print(calculate(10, 5, "+"))   # 15
print(calculate(10, 5, "*"))   # 50
','def calculate(a, b, op):
    if op == "+": return a + b
    elif op == "-": return a - b
    elif op == "*": return a * b
    elif op == "/": return a / b if b != 0 else None
    return None

print(calculate(10, 5, "+"))
print(calculate(10, 5, "*"))','python','["Use if/elif for each operator", "Return the result of each operation", "Be careful with division by zero"]',60,64,true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,description=EXCLUDED.description,is_active=EXCLUDED.is_active;

INSERT INTO chapters (id,language_id,title,description,order_index,icon_emoji,is_active) VALUES
('20000000-0000-0000-0000-000000000001','javascript','JS Fundamentals','Variables, types, and the browser console',1,'⚡',true),
('20000000-0000-0000-0000-000000000002','javascript','DOM & Events','Make web pages interactive',2,'🌐',true),
('20000000-0000-0000-0000-000000000003','javascript','ES6+ Modern JS','Arrow functions, promises, and async/await',3,'🚀',true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,description=EXCLUDED.description,is_active=EXCLUDED.is_active;

INSERT INTO lessons (id,chapter_id,language_id,title,description,type,difficulty,order_index,xp_reward,coin_reward,content,tags,estimated_minutes,is_active) VALUES
('20000001-0000-0000-0000-000000000001','20000000-0000-0000-0000-000000000001','javascript','JavaScript Intro','The language of the web','theory','beginner',1,30,10,'# JavaScript Introduction

JavaScript makes web pages interactive. It runs in every browser.

## Variables
```javascript
let name = "CodeQuest";
const PI = 3.14159;
let score = 0;
score = 100;
```

## Data Types
```javascript
let text = "Hello";
let number = 42;
let isActive = true;
let nothing = null;
```

## Template Literals
```javascript
let player = "Gokul";
let level = 5;
console.log(`Player ${player} is level ${level}`);
```','{"javascript","basics","variables"}',8,true),
('20000001-0000-0000-0000-000000000002','20000000-0000-0000-0000-000000000001','javascript','Functions & Arrays','Core JS building blocks','theory','beginner',2,40,15,'# Functions & Arrays

## Arrow Functions
```javascript
const add = (a, b) => a + b;
const square = x => x * x;
console.log(add(3, 7));
```

## Arrays
```javascript
let fruits = ["apple","banana","cherry"];
fruits.push("date");
const upper = fruits.map(f => f.toUpperCase());
const long = fruits.filter(f => f.length > 5);
const total = [1,2,3,4,5].reduce((sum,n) => sum+n, 0);
```','{"javascript","functions","arrays","arrow-functions"}',12,true),
('20000001-0000-0000-0000-000000000003','20000000-0000-0000-0000-000000000001','javascript','JS Basics Quiz','Test your JavaScript fundamentals','quiz','beginner',3,50,20,'# JavaScript Basics Quiz','{"javascript","quiz","basics"}',5,true),
('20000001-0000-0000-0000-000000000004','20000000-0000-0000-0000-000000000001','javascript','Array Transformer','Manipulate arrays with JS methods','coding','beginner',4,80,35,'# Array Transformer Challenge','{"javascript","challenge","arrays"}',15,true),
('20000001-0000-0000-0000-000000000005','20000000-0000-0000-0000-000000000001','javascript','JS Fundamentals Boss','Defeat the JavaScript Specter!','boss_battle','beginner',5,150,60,'# Boss Battle: The JavaScript Specter','{"javascript","boss","fundamentals"}',20,true),
('20000001-0000-0000-0000-000000000006','20000000-0000-0000-0000-000000000002','javascript','DOM Manipulation','Control your web page with JS','theory','intermediate',1,45,18,'# DOM Manipulation

## Selecting Elements
```javascript
const title = document.getElementById("title");
const buttons = document.querySelectorAll(".btn");
```

## Changing Content
```javascript
const el = document.getElementById("score");
el.textContent = "Score: 100";
el.style.color = "cyan";
el.classList.add("active");
```

## Creating Elements
```javascript
const div = document.createElement("div");
div.textContent = "New element!";
document.body.appendChild(div);
```','{"javascript","dom","web"}',14,true),
('20000001-0000-0000-0000-000000000007','20000000-0000-0000-0000-000000000002','javascript','Events & Listeners','React to user actions','theory','intermediate',2,45,18,'# Events in JavaScript

## Adding Event Listeners
```javascript
const btn = document.getElementById("myBtn");
btn.addEventListener("click", () => {
    btn.textContent = "Clicked!";
});

document.addEventListener("keydown", (e) => {
    console.log("Key pressed:", e.key);
});
```','{"javascript","events","dom","listeners"}',12,true),
('20000001-0000-0000-0000-000000000008','20000000-0000-0000-0000-000000000002','javascript','DOM & Events Quiz','Test your DOM knowledge','quiz','intermediate',3,55,22,'# DOM & Events Quiz','{"javascript","quiz","dom","events"}',5,true),
('20000001-0000-0000-0000-000000000009','20000000-0000-0000-0000-000000000002','javascript','Word Counter Challenge','Count word frequencies','coding','intermediate',4,100,40,'# Word Counter Challenge','{"javascript","challenge","dom"}',25,true),
('20000001-0000-0000-0000-000000000010','20000000-0000-0000-0000-000000000002','javascript','DOM Master Boss','The DOM Demon awaits!','boss_battle','intermediate',5,180,70,'# Boss Battle: The DOM Demon','{"javascript","boss","dom"}',25,true),
('20000001-0000-0000-0000-000000000011','20000000-0000-0000-0000-000000000003','javascript','ES6 Features','Modern JavaScript syntax','theory','intermediate',1,50,20,'# ES6+ Modern JavaScript

## Destructuring
```javascript
const [first, second, ...rest] = [1, 2, 3, 4, 5];
const { name, level, xp = 0 } = player;
```

## Spread Operator
```javascript
const arr2 = [...arr1, 4, 5, 6];
const obj2 = { ...obj1, b: 2 };
```

## Optional Chaining
```javascript
const city = user?.address?.city ?? "Unknown";
```','{"javascript","es6","modern","destructuring"}',14,true),
('20000001-0000-0000-0000-000000000012','20000000-0000-0000-0000-000000000003','javascript','Promises & Async','Handle asynchronous operations','theory','intermediate',2,55,22,'# Promises & Async/Await

## Async/Await
```javascript
async function loadUserData(userId) {
    try {
        const response = await fetch(`/api/users/${userId}`);
        const data = await response.json();
        return data;
    } catch (error) {
        console.error("Failed:", error);
    }
}
```

## Parallel Requests
```javascript
const [user, posts] = await Promise.all([
    fetch("/api/user").then(r => r.json()),
    fetch("/api/posts").then(r => r.json()),
]);
```','{"javascript","async","promises","fetch"}',16,true),
('20000001-0000-0000-0000-000000000013','20000000-0000-0000-0000-000000000003','javascript','Modern JS Quiz','Test your ES6+ knowledge','quiz','intermediate',3,60,25,'# Modern JavaScript Quiz','{"javascript","quiz","es6","async"}',5,true),
('20000001-0000-0000-0000-000000000014','20000000-0000-0000-0000-000000000003','javascript','Async Fetch Challenge','Fetch and display API data','coding','intermediate',4,110,45,'# Async Fetch Challenge','{"javascript","challenge","async","api"}',25,true),
('20000001-0000-0000-0000-000000000015','20000000-0000-0000-0000-000000000003','javascript','Async Ninja Boss','Final JavaScript Boss!','boss_battle','advanced',5,220,90,'# Boss Battle: The Async Ninja','{"javascript","boss","async"}',30,true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,content=EXCLUDED.content,is_active=EXCLUDED.is_active;

INSERT INTO quiz_questions (id,lesson_id,question,options,correct_option_index,explanation,code_snippet,order_index) VALUES
('20000002-0000-0000-0000-000000000001','20000001-0000-0000-0000-000000000003','What is the difference between let and const?','["let can be reassigned, const cannot", "const can be reassigned, let cannot", "They are identical", "let is for numbers, const for strings"]',0,'let allows reassignment. const creates a read-only binding.',NULL,1),
('20000002-0000-0000-0000-000000000002','20000001-0000-0000-0000-000000000003','What does typeof null return?','["\"object\"", "\"null\"", "\"undefined\"", "\"boolean\""]',0,'This is a famous JS quirk! typeof null returns "object" due to a historical bug.',NULL,2),
('20000002-0000-0000-0000-000000000003','20000001-0000-0000-0000-000000000003','What does arr.map(x => x * 2) return for [1,2,3]?','["[2, 4, 6]", "[1, 2, 3]", "[1, 4, 9]", "Error"]',0,'map() creates a new array. x * 2 doubles each element.','const arr = [1, 2, 3];
console.log(arr.map(x => x * 2));',3),
('20000002-0000-0000-0000-000000000004','20000001-0000-0000-0000-000000000003','Which method adds an element to the END of an array?','["push()", "unshift()", "concat()", "append()"]',0,'push() adds to the end. unshift() adds to the beginning.',NULL,4),
('20000002-0000-0000-0000-000000000005','20000001-0000-0000-0000-000000000008','Which method selects ONE element by CSS selector?','["querySelector()", "getElementById()", "querySelectorAll()", "getElement()"]',0,'querySelector() returns the first matching element.',NULL,1),
('20000002-0000-0000-0000-000000000006','20000001-0000-0000-0000-000000000008','What does e.preventDefault() do in a form submit listener?','["Stops the page from reloading", "Deletes the form", "Submits the form twice", "Clears all inputs"]',0,'preventDefault() stops the default browser behavior.',NULL,2),
('20000002-0000-0000-0000-000000000007','20000001-0000-0000-0000-000000000008','How do you add a CSS class to an element?','["element.classList.add(\"myClass\")", "element.class = ''myClass''", "element.addClassName(\"myClass\")", "element.style.class = ''myClass''"]',0,'classList.add() is the correct modern approach.',NULL,3),
('20000002-0000-0000-0000-000000000008','20000001-0000-0000-0000-000000000008','What does user?.profile?.score return?','["3", "undefined", "null", "Error"]',0,'Optional chaining returns undefined if any part is null/undefined.','const user = { profile: { score: 3 } };
console.log(user?.profile?.score);',4),
('20000002-0000-0000-0000-000000000009','20000001-0000-0000-0000-000000000013','What is destructuring?','["Extracting values from arrays/objects into variables", "Deleting properties", "Converting objects to strings", "Breaking a function into parts"]',0,'Destructuring unpacks values from arrays or object properties.',NULL,1),
('20000002-0000-0000-0000-000000000010','20000001-0000-0000-0000-000000000013','What does async/await do?','["Makes asynchronous code look synchronous", "Runs code faster", "Prevents all errors", "Creates worker threads"]',0,'async/await is syntactic sugar over Promises.',NULL,2),
('20000002-0000-0000-0000-000000000011','20000001-0000-0000-0000-000000000013','What is the length of [...arr1, 4, 5, 6] when arr1 = [1,2,3]?','["6", "[1, 2, 3, 4, 5, 6]", "Error", "undefined"]',0,'Spread expands arr1 into the new array, then 4,5,6 are added. Length = 6.','const arr1 = [1, 2, 3];
const arr2 = [...arr1, 4, 5, 6];
console.log(arr2.length);',3),
('20000002-0000-0000-0000-000000000012','20000001-0000-0000-0000-000000000013','What does Promise.all() do?','["Runs multiple promises in parallel and waits for all", "Runs promises one by one", "Returns the fastest promise", "Cancels all promises"]',0,'Promise.all() runs promises in parallel and resolves when ALL complete.',NULL,4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question,options=EXCLUDED.options,correct_option_index=EXCLUDED.correct_option_index;

INSERT INTO coding_challenges (id,lesson_id,title,description,starter_code,solution_code,language_id,hints,time_limit_seconds,memory_limit_mb,is_active) VALUES
('20000003-0000-0000-0000-000000000001','20000001-0000-0000-0000-000000000004','Even Squares','Given array 1..10, return squares of only even numbers.','function evenSquares(arr) {
    // Your code here
}
console.log(evenSquares([1,2,3,4,5,6,7,8,9,10]));
// Expected: [4, 16, 36, 64, 100]','function evenSquares(arr) {
    return arr.filter(x => x % 2 === 0).map(x => x * x);
}
console.log(evenSquares([1,2,3,4,5,6,7,8,9,10]));','javascript','["Use filter() to get only even numbers", "Use map() to square each number", "Chain the two methods"]',30,64,true),
('20000003-0000-0000-0000-000000000002','20000001-0000-0000-0000-000000000009','Word Counter','Write wordCount(str) returning object with each word and its frequency.','function wordCount(str) {
    // Your code here
}
console.log(wordCount("the cat sat on the mat the cat"));','function wordCount(str) {
    const counts = {};
    str.split(" ").forEach(word => {
        counts[word] = (counts[word] || 0) + 1;
    });
    return counts;
}
console.log(wordCount("the cat sat on the mat the cat"));','javascript','["Split the string using split( )", "Use an empty object to store counts", "Increment counts for each word"]',60,64,true),
('20000003-0000-0000-0000-000000000003','20000001-0000-0000-0000-000000000014','Async Fetcher','Write async fetchUser(id) returning name and email.','async function fetchUser(id) {
    // Your code here
    // Return { name, email }
}
fetchUser(1).then(user => console.log(user));','async function fetchUser(id) {
    try {
        const response = await fetch(`https://jsonplaceholder.typicode.com/users/${id}`);
        const data = await response.json();
        return { name: data.name, email: data.email };
    } catch (error) {
        return null;
    }
}
fetchUser(1).then(user => console.log(user));','javascript','["Use async/await syntax", "Use template literal for URL", "Call response.json() to parse", "Wrap in try/catch"]',90,64,true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,description=EXCLUDED.description,is_active=EXCLUDED.is_active;
