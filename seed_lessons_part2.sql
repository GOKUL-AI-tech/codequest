-- CodeQuest Seed: Dart & Java (Part 2)
-- Generated fresh - no ARRAY[] syntax used

INSERT INTO chapters (id,language_id,title,description,order_index,icon_emoji,is_active) VALUES
('30000000-0000-0000-0000-000000000001','dart','Dart Basics','Variables, types and null safety',1,'🎯',true),
('30000000-0000-0000-0000-000000000002','dart','OOP in Dart','Classes, constructors and mixins',2,'🏗️',true),
('30000000-0000-0000-0000-000000000003','dart','Async Dart','Futures, streams and async/await',3,'⚡',true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,description=EXCLUDED.description,is_active=EXCLUDED.is_active;

INSERT INTO lessons (id,chapter_id,language_id,title,description,type,difficulty,order_index,xp_reward,coin_reward,content,tags,estimated_minutes,is_active) VALUES
('30000001-0000-0000-0000-000000000001','30000000-0000-0000-0000-000000000001','dart','Dart Fundamentals','Variables and null safety in Dart','theory','beginner',1,30,10,'# Dart Basics

Dart is Google''s language powering Flutter apps.

## Variables
```dart
var name = ''CodeQuest'';
String greeting = ''Hello'';
int level = 5;
double xp = 1250.0;
bool isActive = true;
```

## Null Safety
```dart
String? nullableName;
String nonNullable = ''always a value'';
print(nullableName ?? ''Guest'');
```

## String Interpolation
```dart
String player = ''Gokul'';
int lvl = 5;
print(''Player $player is level $lvl'');
print(''Next level XP: ${lvl * 100}'');
```','{"dart","basics","null-safety"}',8,true),
('30000001-0000-0000-0000-000000000002','30000000-0000-0000-0000-000000000001','dart','Collections in Dart','Lists, maps and sets','theory','beginner',2,40,15,'# Collections in Dart

## Lists
```dart
List<int> nums = [1, 2, 3];
nums.add(4);
final squares = nums.map((n) => n * n).toList();
final evens = nums.where((n) => n % 2 == 0).toList();
```

## Maps
```dart
Map<String, int> scores = {''Alice'': 90, ''Bob'': 85};
scores[''Gokul''] = 95;
scores.forEach((name, score) => print(''$name: $score''));
```

## Sets
```dart
Set<String> langs = {''dart'', ''python'', ''dart''};
print(langs.length);  // 2 - no duplicates
```','{"dart","collections","list","map"}',12,true),
('30000001-0000-0000-0000-000000000003','30000000-0000-0000-0000-000000000001','dart','Dart Basics Quiz','Test your Dart fundamentals','quiz','beginner',3,50,20,'# Dart Basics Quiz','{"dart","quiz","basics"}',5,true),
('30000001-0000-0000-0000-000000000004','30000000-0000-0000-0000-000000000001','dart','List Filter Challenge','Filter and transform lists','coding','beginner',4,80,35,'# List Filter Challenge','{"dart","challenge","collections"}',15,true),
('30000001-0000-0000-0000-000000000005','30000000-0000-0000-0000-000000000001','dart','Dart Basics Boss','Beat the Null Pointer!','boss_battle','beginner',5,150,60,'# Boss Battle: The Null Pointer','{"dart","boss","basics"}',20,true),
('30000001-0000-0000-0000-000000000006','30000000-0000-0000-0000-000000000002','dart','Classes in Dart','OOP with Dart classes','theory','intermediate',1,45,18,'# Classes in Dart

```dart
class Player {
  String name;
  int level;
  int xp;

  Player(this.name) : level = 1, xp = 0;

  void gainXP(int amount) {
    xp += amount;
    if (xp >= 100) {
      xp -= 100;
      level++;
      print(''$name leveled up to $level!'');
    }
  }

  @override
  String toString() => ''Player($name, Lv$level)'';
}

void main() {
  var p = Player(''Gokul'');
  p.gainXP(120);
  print(p);
}
```','{"dart","classes","oop"}',14,true),
('30000001-0000-0000-0000-000000000007','30000000-0000-0000-0000-000000000002','dart','Inheritance & Mixins','Extend classes with Dart mixins','theory','intermediate',2,50,20,'# Inheritance & Mixins

```dart
abstract class Character {
  String name;
  int health;
  Character(this.name) : health = 100;
  void attack();
}

mixin Healer {
  int heal(int amount) => amount * 2;
}

class Warrior extends Character with Healer {
  Warrior(String name) : super(name);
  @override
  void attack() => print(''$name swings sword!'');
}
```','{"dart","inheritance","mixins"}',16,true),
('30000001-0000-0000-0000-000000000008','30000000-0000-0000-0000-000000000002','dart','Dart OOP Quiz','Test your OOP knowledge','quiz','intermediate',3,55,22,'# Dart OOP Quiz','{"dart","quiz","oop"}',5,true),
('30000001-0000-0000-0000-000000000009','30000000-0000-0000-0000-000000000002','dart','Shape Area Challenge','Polymorphism with shapes','coding','intermediate',4,100,40,'# Shape Area Challenge','{"dart","challenge","oop"}',20,true),
('30000001-0000-0000-0000-000000000010','30000000-0000-0000-0000-000000000002','dart','Dart OOP Boss','Defeat the Abstract Beast!','boss_battle','intermediate',5,180,70,'# Boss Battle: The Abstract Beast','{"dart","boss","oop"}',25,true),
('30000001-0000-0000-0000-000000000011','30000000-0000-0000-0000-000000000003','dart','Futures & Async','Async programming in Dart','theory','intermediate',1,50,20,'# Futures & Async in Dart

## Async/Await
```dart
Future<String> fetchUser(int id) async {
  await Future.delayed(Duration(seconds: 1));
  return ''User $id'';
}

void main() async {
  String user = await fetchUser(1);
  print(user);
}
```

## Streams
```dart
Stream<int> countdown(int n) async* {
  for (int i = n; i >= 0; i--) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

void main() async {
  await for (int n in countdown(3)) {
    print(n);
  }
}
```','{"dart","async","future"}',14,true),
('30000001-0000-0000-0000-000000000012','30000000-0000-0000-0000-000000000003','dart','Streams in Dart','Reactive streams with Dart','theory','intermediate',2,55,22,'# Stream Operators

```dart
final stream = Stream.fromIterable([1, 2, 3, 4, 5]);

stream
  .where((n) => n % 2 == 0)
  .map((n) => n * n)
  .listen((n) => print(n));
```','{"dart","streams","async"}',16,true),
('30000001-0000-0000-0000-000000000013','30000000-0000-0000-0000-000000000003','dart','Async Dart Quiz','Test your async knowledge','quiz','intermediate',3,60,25,'# Async Dart Quiz','{"dart","quiz","async","future"}',5,true),
('30000001-0000-0000-0000-000000000014','30000000-0000-0000-0000-000000000003','dart','Async Timer Challenge','Build an async countdown timer','coding','intermediate',4,110,45,'# Async Timer Challenge','{"dart","challenge","async"}',25,true),
('30000001-0000-0000-0000-000000000015','30000000-0000-0000-0000-000000000003','dart','Stream Boss','The Stream Serpent awaits!','boss_battle','advanced',5,220,90,'# Boss Battle: The Stream Serpent','{"dart","boss","streams"}',30,true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,content=EXCLUDED.content,is_active=EXCLUDED.is_active;

INSERT INTO quiz_questions (id,lesson_id,question,options,correct_option_index,explanation,code_snippet,order_index) VALUES
('30000002-0000-0000-0000-000000000001','30000001-0000-0000-0000-000000000003','What keyword makes a variable nullable in Dart?','["?", "!", "nullable", "null"]',0,'Appending ? to a type (e.g. String?) allows it to hold null.',NULL,1),
('30000002-0000-0000-0000-000000000002','30000001-0000-0000-0000-000000000003','What does the ?? operator do?','["Returns the right side if the left is null", "Checks equality", "Throws an error", "Creates a nullable type"]',0,'The null coalescing operator ?? returns the left value if non-null, otherwise the right.','String? name;
print(name ?? ''Guest'');',2),
('30000002-0000-0000-0000-000000000003','30000001-0000-0000-0000-000000000003','How do you create a typed list in Dart?','["List<int> nums = [1, 2, 3]", "int[] nums = [1, 2, 3]", "Array<int> nums = [1, 2, 3]", "nums = List.of([1, 2, 3])"]',0,'Dart uses generics for typed collections. List<int> declares a list that only holds integers.',NULL,3),
('30000002-0000-0000-0000-000000000004','30000001-0000-0000-0000-000000000003','How do you safely access a nullable property?','["obj?.property", "obj!.property", "obj.property", "obj[property]"]',0,'?. is the null-aware access operator. Returns null if obj is null instead of throwing.',NULL,4),
('30000002-0000-0000-0000-000000000005','30000001-0000-0000-0000-000000000008','What keyword creates a class in Dart?','["class", "object", "struct", "type"]',0,'Dart uses the class keyword, same as Java and C++.',NULL,1),
('30000002-0000-0000-0000-000000000006','30000001-0000-0000-0000-000000000008','What is a mixin in Dart?','["A way to reuse code in multiple classes", "A type of loop", "An abstract class", "A nullable type"]',0,'Mixins allow you to reuse a class''s code in multiple class hierarchies.',NULL,2),
('30000002-0000-0000-0000-000000000007','30000001-0000-0000-0000-000000000008','What does the @override annotation do?','["Marks a method that overrides a parent method", "Creates a new method", "Makes a method private", "Prevents inheritance"]',0,'@override indicates you are intentionally overriding a superclass method.',NULL,3),
('30000002-0000-0000-0000-000000000008','30000001-0000-0000-0000-000000000008','What is a constructor shorthand in Dart?','["Player(this.name)", "Player(name)", "new Player(name)", "Player{name}"]',0,'this.name in constructor params automatically assigns the parameter to the field.',NULL,4),
('30000002-0000-0000-0000-000000000009','30000001-0000-0000-0000-000000000013','What does async* with yield create?','["A Stream", "A Future", "A List", "An Iterator"]',0,'async* with yield creates a Stream generator.',NULL,1),
('30000002-0000-0000-0000-000000000010','30000001-0000-0000-0000-000000000013','What does await do?','["Pauses execution until the Future completes", "Runs code in parallel", "Creates a new thread", "Cancels a Future"]',0,'await pauses the async function until the Future resolves.',NULL,2),
('30000002-0000-0000-0000-000000000011','30000001-0000-0000-0000-000000000013','What does async* produce?','["A Stream", "A Future", "A List", "An Iterator"]',0,'async* with yield creates a Stream generator. Each yield emits a value to the stream.',NULL,3),
('30000002-0000-0000-0000-000000000012','30000001-0000-0000-0000-000000000013','What keyword marks a function as asynchronous?','["async", "await", "future", "stream"]',0,'The async keyword marks a function as asynchronous and allows use of await inside.',NULL,4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question,options=EXCLUDED.options,correct_option_index=EXCLUDED.correct_option_index;

INSERT INTO coding_challenges (id,lesson_id,title,description,starter_code,solution_code,language_id,hints,time_limit_seconds,memory_limit_mb,is_active) VALUES
('30000003-0000-0000-0000-000000000001','30000001-0000-0000-0000-000000000004','List Filter','Write getEvenNumbers returning only even numbers.','List<int> getEvenNumbers(List<int> nums) {
  // Your code here
  return [];
}
void main() {
  print(getEvenNumbers([1,2,3,4,5,6,7,8]));
  // Expected: [2, 4, 6, 8]
}','List<int> getEvenNumbers(List<int> nums) {
  return nums.where((n) => n % 2 == 0).toList();
}
void main() {
  print(getEvenNumbers([1,2,3,4,5,6,7,8]));
}','dart','["Use the where() method to filter", "Pass a lambda: (n) => n % 2 == 0", "Add .toList() at the end"]',30,64,true),
('30000003-0000-0000-0000-000000000002','30000001-0000-0000-0000-000000000009','Shape Area','Create Circle and Rectangle extending Shape.','abstract class Shape {
  double area();
}
// Add Circle and Rectangle classes
void main() {
  List<Shape> shapes = [Circle(5), Rectangle(4, 6)];
  for (var s in shapes) print(s.area());
}','import ''dart:math'';
abstract class Shape { double area(); }
class Circle extends Shape {
  final double radius;
  Circle(this.radius);
  @override double area() => pi * radius * radius;
}
class Rectangle extends Shape {
  final double w, h;
  Rectangle(this.w, this.h);
  @override double area() => w * h;
}
void main() {
  List<Shape> shapes = [Circle(5), Rectangle(4, 6)];
  for (var s in shapes) print(s.area());
}','dart','["Use abstract class Shape with area()", "Circle area = pi * r * r", "Rectangle area = width * height", "Import dart:math for pi"]',60,64,true),
('30000003-0000-0000-0000-000000000003','30000001-0000-0000-0000-000000000014','Async Add','Write addAsync(a, b) that returns a+b asynchronously.','Future<int> addAsync(int a, int b) async {
  // Simulate async work
  await Future.delayed(Duration(milliseconds: 100));
  // Return a + b
}
void main() async {
  print(await addAsync(3, 7));  // 10
}','Future<int> addAsync(int a, int b) async {
  await Future.delayed(Duration(milliseconds: 100));
  return a + b;
}
void main() async {
  print(await addAsync(3, 7));
}','dart','["Mark the function with async", "Use await Future.delayed() for async simulation", "Return a + b as the result"]',30,64,true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,description=EXCLUDED.description,is_active=EXCLUDED.is_active;

INSERT INTO chapters (id,language_id,title,description,order_index,icon_emoji,is_active) VALUES
('40000000-0000-0000-0000-000000000001','java','Java Basics','Syntax, types, and OOP fundamentals',1,'☕',true),
('40000000-0000-0000-0000-000000000002','java','OOP in Java','Classes, interfaces, and polymorphism',2,'🏗️',true),
('40000000-0000-0000-0000-000000000003','java','Collections & Streams','ArrayList, HashMap, and Java Streams',3,'📚',true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,description=EXCLUDED.description,is_active=EXCLUDED.is_active;

INSERT INTO lessons (id,chapter_id,language_id,title,description,type,difficulty,order_index,xp_reward,coin_reward,content,tags,estimated_minutes,is_active) VALUES
('40000001-0000-0000-0000-000000000001','40000000-0000-0000-0000-000000000001','java','Java Basics','Variables and types in Java','theory','beginner',1,30,10,'# Java Basics

Java is a strongly-typed, object-oriented language.

## Hello World
```java
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, CodeQuest!");
    }
}
```

## Variables & Types
```java
int level = 5;
double xp = 1250.5;
boolean isActive = true;
String name = "Gokul";
char grade = ''A'';
```

## Type Casting
```java
int x = (int) 3.14;
double d = (double) 10 / 3;
String s = String.valueOf(42);
int n = Integer.parseInt("42");
```','{"java","basics","types"}',10,true),
('40000001-0000-0000-0000-000000000002','40000000-0000-0000-0000-000000000001','java','Control Flow','Loops and conditionals in Java','theory','beginner',2,40,15,'# Control Flow in Java

## If-Else
```java
int score = 85;
if (score >= 90) {
    System.out.println("A");
} else if (score >= 80) {
    System.out.println("B");
} else {
    System.out.println("F");
}
```

## For Loop
```java
for (int i = 0; i < 5; i++) {
    System.out.println(i);
}

int[] scores = {90, 75, 88};
for (int s : scores) {
    System.out.println(s);
}
```

## While Loop
```java
int count = 0;
while (count < 5) {
    System.out.println(count++);
}
```','{"java","loops","conditionals"}',12,true),
('40000001-0000-0000-0000-000000000003','40000000-0000-0000-0000-000000000001','java','Java Basics Quiz','Test your Java fundamentals','quiz','beginner',3,50,20,'# Java Basics Quiz','{"java","quiz","basics"}',5,true),
('40000001-0000-0000-0000-000000000004','40000000-0000-0000-0000-000000000001','java','FizzBuzz Java','Classic FizzBuzz in Java','coding','beginner',4,80,35,'# FizzBuzz Java Challenge','{"java","challenge","loops"}',15,true),
('40000001-0000-0000-0000-000000000005','40000000-0000-0000-0000-000000000001','java','Java Basics Boss','Defeat the NullPointerException!','boss_battle','beginner',5,150,60,'# Boss Battle: NullPointerException','{"java","boss","basics"}',20,true),
('40000001-0000-0000-0000-000000000006','40000000-0000-0000-0000-000000000002','java','Classes in Java','OOP with Java classes','theory','intermediate',1,45,18,'# Classes in Java

```java
public class Player {
    private String name;
    private int level;
    private int xp;

    public Player(String name) {
        this.name = name;
        this.level = 1;
        this.xp = 0;
    }

    public void gainXP(int amount) {
        xp += amount;
        if (xp >= 100) {
            xp -= 100;
            level++;
            System.out.println(name + " reached level " + level);
        }
    }

    public String getName() { return name; }
    public int getLevel() { return level; }
}
```','{"java","classes","oop"}',14,true),
('40000001-0000-0000-0000-000000000007','40000000-0000-0000-0000-000000000002','java','Interfaces in Java','Interfaces and abstract classes','theory','intermediate',2,50,20,'# Interfaces & Inheritance

```java
interface Attackable {
    void attack();
    default void defend() {
        System.out.println("Defending!");
    }
}

abstract class Character implements Attackable {
    protected String name;
    public Character(String name) { this.name = name; }
}

class Warrior extends Character {
    public Warrior(String name) { super(name); }
    @Override
    public void attack() {
        System.out.println(name + " swings sword!");
    }
}
```','{"java","interfaces","inheritance"}',16,true),
('40000001-0000-0000-0000-000000000008','40000000-0000-0000-0000-000000000002','java','Java OOP Quiz','Test your Java OOP knowledge','quiz','intermediate',3,55,22,'# Java OOP Quiz','{"java","quiz","oop"}',5,true),
('40000001-0000-0000-0000-000000000009','40000000-0000-0000-0000-000000000002','java','Shapes Challenge','Polymorphism with Java shapes','coding','intermediate',4,100,40,'# Java Shapes Challenge','{"java","challenge","oop"}',20,true),
('40000001-0000-0000-0000-000000000010','40000000-0000-0000-0000-000000000002','java','Java OOP Boss','The Abstract Phantom strikes!','boss_battle','intermediate',5,180,70,'# Boss Battle: The Abstract Phantom','{"java","boss","oop"}',25,true),
('40000001-0000-0000-0000-000000000011','40000000-0000-0000-0000-000000000003','java','Collections in Java','ArrayList and HashMap','theory','intermediate',1,50,20,'# Collections in Java

## ArrayList
```java
import java.util.ArrayList;
ArrayList<String> names = new ArrayList<>();
names.add("Alice");
names.add("Bob");
names.remove("Alice");
for (String n : names) System.out.println(n);
```

## HashMap
```java
import java.util.HashMap;
HashMap<String, Integer> scores = new HashMap<>();
scores.put("Alice", 90);
scores.put("Bob", 85);
System.out.println(scores.get("Alice"));
scores.forEach((k, v) -> System.out.println(k + ": " + v));
```','{"java","collections","arraylist","hashmap"}',14,true),
('40000001-0000-0000-0000-000000000012','40000000-0000-0000-0000-000000000003','java','Java Streams','Functional-style data processing','theory','intermediate',2,55,22,'# Java Streams

```java
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

List<Integer> nums = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

List<Integer> evenSquares = nums.stream()
    .filter(n -> n % 2 == 0)
    .map(n -> n * n)
    .collect(Collectors.toList());

int total = nums.stream().mapToInt(Integer::intValue).sum();
```','{"java","streams","lambda"}',16,true),
('40000001-0000-0000-0000-000000000013','40000000-0000-0000-0000-000000000003','java','Java Collections Quiz','Test your Collections knowledge','quiz','intermediate',3,60,25,'# Java Collections Quiz','{"java","quiz","collections"}',5,true),
('40000001-0000-0000-0000-000000000014','40000000-0000-0000-0000-000000000003','java','Word Frequency','Count word frequencies with HashMap','coding','intermediate',4,110,45,'# Word Frequency Challenge','{"java","challenge","hashmap"}',25,true),
('40000001-0000-0000-0000-000000000015','40000000-0000-0000-0000-000000000003','java','Stream Master Boss','Final Java Boss!','boss_battle','advanced',5,220,90,'# Boss Battle: The Stream Master','{"java","boss","streams"}',30,true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,content=EXCLUDED.content,is_active=EXCLUDED.is_active;

INSERT INTO quiz_questions (id,lesson_id,question,options,correct_option_index,explanation,code_snippet,order_index) VALUES
('40000002-0000-0000-0000-000000000001','40000001-0000-0000-0000-000000000003','What is the main method signature in Java?','["public static void main(String[] args)", "void main()", "public void main(String args)", "static main()"]',0,'The exact signature public static void main(String[] args) is required for Java entry point.',NULL,1),
('40000002-0000-0000-0000-000000000002','40000001-0000-0000-0000-000000000003','Which is NOT a Java primitive type?','["String", "int", "double", "boolean"]',0,'String is an object (class), not a primitive type.',NULL,2),
('40000002-0000-0000-0000-000000000003','40000001-0000-0000-0000-000000000003','How do you convert String to int in Java?','["Integer.parseInt(str)", "int.parse(str)", "(int)str", "str.toInt()"]',0,'Integer.parseInt() converts a String to an int.',NULL,3),
('40000002-0000-0000-0000-000000000004','40000001-0000-0000-0000-000000000003','What does System.out.println() do?','["Prints to console with newline", "Prints without newline", "Reads from console", "Exits the program"]',0,'println prints the argument followed by a newline character.',NULL,4),
('40000002-0000-0000-0000-000000000005','40000001-0000-0000-0000-000000000008','What is the difference between abstract class and interface?','["Abstract class can have state; interface cannot (before Java 8)", "They are identical", "Interface can have constructors", "Abstract class cannot be extended"]',0,'Abstract classes can have fields and constructors; interfaces define contracts.',NULL,1),
('40000002-0000-0000-0000-000000000006','40000001-0000-0000-0000-000000000008','What keyword implements an interface?','["implements", "extends", "interface", "override"]',0,'Classes use implements for interfaces and extends for inheritance.',NULL,2),
('40000002-0000-0000-0000-000000000007','40000001-0000-0000-0000-000000000008','What does @Override annotation do?','["Marks a method overriding a superclass method", "Creates a new method", "Makes a method private", "Runs at compile time only"]',0,'@Override tells the compiler you are intentionally overriding a parent method.',NULL,3),
('40000002-0000-0000-0000-000000000008','40000001-0000-0000-0000-000000000008','What is encapsulation?','["Hiding internal state using private fields and public methods", "Inheriting from a base class", "Implementing an interface", "Making all methods static"]',0,'Encapsulation bundles data and methods while hiding internal state.',NULL,4),
('40000002-0000-0000-0000-000000000009','40000001-0000-0000-0000-000000000013','Which class is the most common dynamic array in Java?','["ArrayList", "LinkedList", "Vector", "Array"]',0,'ArrayList is the most common dynamic array in Java.',NULL,1),
('40000002-0000-0000-0000-000000000010','40000001-0000-0000-0000-000000000013','How do you get a value from a HashMap?','["map.get(key)", "map.value(key)", "map.fetch(key)", "map[key]"]',0,'HashMap uses the get(key) method to retrieve values.',NULL,2),
('40000002-0000-0000-0000-000000000011','40000001-0000-0000-0000-000000000013','What does a HashSet guarantee?','["No duplicate elements", "Elements in insertion order", "Alphabetical sorting", "Thread safety"]',0,'HashSet stores unique elements with no guaranteed order.',NULL,3),
('40000002-0000-0000-0000-000000000012','40000001-0000-0000-0000-000000000013','What does stream().filter() do?','["Returns elements matching a predicate", "Transforms each element", "Combines all elements", "Sorts the stream"]',0,'filter() keeps only elements that match the given predicate.',NULL,4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question,options=EXCLUDED.options,correct_option_index=EXCLUDED.correct_option_index;

INSERT INTO coding_challenges (id,lesson_id,title,description,starter_code,solution_code,language_id,hints,time_limit_seconds,memory_limit_mb,is_active) VALUES
('40000003-0000-0000-0000-000000000001','40000001-0000-0000-0000-000000000004','FizzBuzz Java','Print FizzBuzz for 1-20 in Java.','public class Main {
    public static void main(String[] args) {
        for (int i = 1; i <= 20; i++) {
            // Your code here
        }
    }
}','public class Main {
    public static void main(String[] args) {
        for (int i = 1; i <= 20; i++) {
            if (i % 15 == 0) System.out.println("FizzBuzz");
            else if (i % 3 == 0) System.out.println("Fizz");
            else if (i % 5 == 0) System.out.println("Buzz");
            else System.out.println(i);
        }
    }
}','java','["Check divisible by 15 first", "Use % operator for divisibility", "Use System.out.println"]',30,64,true),
('40000003-0000-0000-0000-000000000002','40000001-0000-0000-0000-000000000014','Word Frequency','Count word frequencies using HashMap.','import java.util.*;
public class Main {
    public static void main(String[] args) {
        String[] words = {"the","cat","sat","on","the","mat","the","cat"};
        // Count frequencies using HashMap
    }
}','import java.util.*;
public class Main {
    public static void main(String[] args) {
        String[] words = {"the","cat","sat","on","the","mat","the","cat"};
        HashMap<String,Integer> freq = new HashMap<>();
        for (String w : words) freq.put(w, freq.getOrDefault(w, 0) + 1);
        freq.forEach((k, v) -> System.out.println(k + ": " + v));
    }
}','java','["Use HashMap<String,Integer>", "Use getOrDefault(word, 0) for safe count", "Increment with put(word, count+1)"]',60,64,true),
('40000003-0000-0000-0000-000000000003','40000001-0000-0000-0000-000000000009','Even Squares Stream','Use Java streams to get squares of even numbers.','import java.util.*;
import java.util.stream.*;
public class Main {
    public static void main(String[] args) {
        List<Integer> nums = Arrays.asList(1,2,3,4,5,6,7,8,9,10);
        // Use streams to get squares of even numbers
    }
}','import java.util.*;
import java.util.stream.*;
public class Main {
    public static void main(String[] args) {
        List<Integer> nums = Arrays.asList(1,2,3,4,5,6,7,8,9,10);
        List<Integer> result = nums.stream()
            .filter(n -> n % 2 == 0)
            .map(n -> n * n)
            .collect(Collectors.toList());
        System.out.println(result);
    }
}','java','["Use stream().filter() to get even numbers", "Use stream().map() to square each", "Use collect(Collectors.toList()) at end"]',60,64,true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,description=EXCLUDED.description,is_active=EXCLUDED.is_active;
