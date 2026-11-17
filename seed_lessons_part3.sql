-- CodeQuest Seed: C++ & C (Part 3)
-- Generated fresh - no ARRAY[] syntax used

INSERT INTO chapters (id,language_id,title,description,order_index,icon_emoji,is_active) VALUES
('50000000-0000-0000-0000-000000000001','cpp','C++ Foundations','Syntax, pointers, and memory basics',1,'⚡',true),
('50000000-0000-0000-0000-000000000002','cpp','OOP in C++','Classes, constructors, and polymorphism',2,'🏗️',true),
('50000000-0000-0000-0000-000000000003','cpp','STL & Templates','Vectors, maps, and the Standard Template Library',3,'📚',true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,description=EXCLUDED.description,is_active=EXCLUDED.is_active;

INSERT INTO lessons (id,chapter_id,language_id,title,description,type,difficulty,order_index,xp_reward,coin_reward,content,tags,estimated_minutes,is_active) VALUES
('50000001-0000-0000-0000-000000000001','50000000-0000-0000-0000-000000000001','cpp','C++ Introduction','The power language - fast and flexible','theory','beginner',1,30,10,'# C++ Introduction

C++ is a high-performance language used in game development, systems programming, and competitive coding.

## Hello World
```cpp
#include <iostream>
using namespace std;

int main() {
    cout << "Hello, CodeQuest!" << endl;
    return 0;
}
```

## Variables & Types
```cpp
int level = 5;
double xp = 1250.5;
bool isActive = true;
string name = "Gokul";
```

## Constants
```cpp
const int MAX_LEVEL = 100;
const double PI = 3.14159265;
```','{"cpp","basics","hello-world","iostream"}',10,true),
('50000001-0000-0000-0000-000000000002','50000000-0000-0000-0000-000000000001','cpp','Pointers & References','Memory management in C++','theory','intermediate',2,50,20,'# Pointers & References

## Pointers
```cpp
int x = 42;
int* ptr = &x;

cout << x;     // 42 (value)
cout << *ptr;  // 42 (dereference)

*ptr = 100;
cout << x;     // 100
```

## References
```cpp
int score = 50;
int& ref = score;
ref = 99;
cout << score;  // 99

void doubleValue(int& n) { n *= 2; }
int val = 5;
doubleValue(val);
cout << val;  // 10
```

## nullptr
```cpp
int* ptr = nullptr;
if (ptr != nullptr) { cout << *ptr; }
```','{"cpp","pointers","references","memory"}',14,true),
('50000001-0000-0000-0000-000000000003','50000000-0000-0000-0000-000000000001','cpp','C++ Basics Quiz','Test your C++ fundamentals','quiz','beginner',3,50,20,'# C++ Basics Quiz','{"cpp","quiz","basics","pointers"}',5,true),
('50000001-0000-0000-0000-000000000004','50000000-0000-0000-0000-000000000001','cpp','Pointer Puzzle','Master pointers with coding','coding','intermediate',4,90,38,'# Pointer Puzzle Challenge','{"cpp","challenge","pointers"}',20,true),
('50000001-0000-0000-0000-000000000005','50000000-0000-0000-0000-000000000001','cpp','Memory Demon Boss','Defeat the Memory Demon!','boss_battle','intermediate',5,160,65,'# Boss Battle: The Memory Demon','{"cpp","boss","pointers","memory"}',25,true),
('50000001-0000-0000-0000-000000000006','50000000-0000-0000-0000-000000000002','cpp','Classes in C++','OOP the C++ way','theory','intermediate',1,45,18,'# Classes in C++

```cpp
class Player {
private:
    string name;
    int level;
    int xp;

public:
    Player(string name) : name(name), level(1), xp(0) {}
    ~Player() { cout << name << " disconnected." << endl; }

    void gainXP(int amount) {
        xp += amount;
        while (xp >= 100) {
            xp -= 100;
            level++;
            cout << name << " reached level " << level << "!" << endl;
        }
    }

    string getName() const { return name; }
    int getLevel() const { return level; }
};
```','{"cpp","classes","oop","constructor"}',14,true),
('50000001-0000-0000-0000-000000000007','50000000-0000-0000-0000-000000000002','cpp','Inheritance & Virtual','Polymorphism in C++','theory','intermediate',2,50,20,'# Inheritance & Virtual Functions

```cpp
class Character {
protected:
    string name;
    int health;
public:
    Character(string name) : name(name), health(100) {}
    virtual void attack() { cout << name << " attacks!" << endl; }
    virtual ~Character() {}
};

class Warrior : public Character {
    int armor;
public:
    Warrior(string name) : Character(name), armor(15) {}
    void attack() override {
        cout << name << " smashes with sword!" << endl;
    }
};

class Mage : public Character {
public:
    Mage(string name) : Character(name) {}
    void attack() override {
        cout << name << " casts fireball!" << endl;
    }
};
```','{"cpp","inheritance","virtual","polymorphism"}',16,true),
('50000001-0000-0000-0000-000000000008','50000000-0000-0000-0000-000000000002','cpp','C++ OOP Quiz','Test your C++ OOP knowledge','quiz','intermediate',3,55,22,'# C++ OOP Quiz','{"cpp","quiz","oop","virtual"}',5,true),
('50000001-0000-0000-0000-000000000009','50000000-0000-0000-0000-000000000002','cpp','Shape Polymorphism','Build a shape hierarchy','coding','intermediate',4,100,40,'# Shape Polymorphism Challenge','{"cpp","challenge","oop","virtual"}',20,true),
('50000001-0000-0000-0000-000000000010','50000000-0000-0000-0000-000000000002','cpp','Vtable Vampire Boss','The Vtable Vampire strikes!','boss_battle','intermediate',5,180,70,'# Boss Battle: The Vtable Vampire','{"cpp","boss","oop","virtual"}',25,true),
('50000001-0000-0000-0000-000000000011','50000000-0000-0000-0000-000000000003','cpp','Vectors & Arrays','STL sequence containers','theory','intermediate',1,50,20,'# Vectors in C++

```cpp
#include <vector>
#include <algorithm>
using namespace std;

vector<int> scores = {90, 75, 88, 92, 65};
scores.push_back(100);
scores.pop_back();

for (int s : scores) { cout << s << " "; }

sort(scores.begin(), scores.end());
int mx = *max_element(scores.begin(), scores.end());
auto it = find(scores.begin(), scores.end(), 88);
```','{"cpp","vector","stl","algorithms"}',14,true),
('50000001-0000-0000-0000-000000000012','50000000-0000-0000-0000-000000000003','cpp','Maps & Sets','STL associative containers','theory','intermediate',2,50,20,'# Maps & Sets in C++

## Map
```cpp
#include <map>
#include <unordered_map>
map<string, int> scores;
scores["Gokul"] = 1250;
scores["Alice"] = 980;

for (auto& [name, score] : scores) {
    cout << name << ": " << score << endl;
}

unordered_map<string, int> fast;
fast["key"] = 42;
```

## Set
```cpp
#include <set>
set<int> unique_scores = {90, 75, 88, 90};
unique_scores.insert(100);
bool found = unique_scores.count(88) > 0;
```','{"cpp","map","set","stl"}',14,true),
('50000001-0000-0000-0000-000000000013','50000000-0000-0000-0000-000000000003','cpp','STL Quiz','Test your STL knowledge','quiz','intermediate',3,55,22,'# C++ STL Quiz','{"cpp","quiz","stl","vector","map"}',5,true),
('50000001-0000-0000-0000-000000000014','50000000-0000-0000-0000-000000000003','cpp','Two Sum Challenge','Classic interview problem with unordered_map','coding','intermediate',4,100,40,'# Two Sum Challenge','{"cpp","challenge","stl","algorithms"}',20,true),
('50000001-0000-0000-0000-000000000015','50000000-0000-0000-0000-000000000003','cpp','STL Sorcerer Boss','Final C++ Boss!','boss_battle','advanced',5,220,90,'# Boss Battle: The STL Sorcerer','{"cpp","boss","stl"}',30,true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,content=EXCLUDED.content,is_active=EXCLUDED.is_active;

INSERT INTO quiz_questions (id,lesson_id,question,options,correct_option_index,explanation,code_snippet,order_index) VALUES
('50000002-0000-0000-0000-000000000001','50000001-0000-0000-0000-000000000003','What does the * operator do with a pointer?','["Dereferences the pointer to get the value", "Creates a new pointer", "Multiplies two numbers", "Deletes the pointer"]',0,'*ptr dereferences the value at the memory address stored in ptr.','int x = 42;
int* ptr = &x;
cout << *ptr;',1),
('50000002-0000-0000-0000-000000000002','50000001-0000-0000-0000-000000000003','What is nullptr in C++?','["A safe null pointer constant", "An empty string", "A zero integer", "A deleted pointer"]',0,'nullptr is a type-safe null pointer constant introduced in C++11.',NULL,2),
('50000002-0000-0000-0000-000000000003','50000001-0000-0000-0000-000000000003','What does & mean in void f(int& x)?','["Pass by reference", "Take the address", "Bitwise AND", "Create a pointer"]',0,'In a function signature, & means pass by reference.',NULL,3),
('50000002-0000-0000-0000-000000000004','50000001-0000-0000-0000-000000000003','Which header is needed for cout and cin?','["<iostream>", "<stdio.h>", "<string>", "<cstdlib>"]',0,'<iostream> provides cout (output) and cin (input).',NULL,4),
('50000002-0000-0000-0000-000000000005','50000001-0000-0000-0000-000000000008','What is a virtual function?','["A function that can be overridden by a derived class", "A function that does not exist", "A private function", "A static function"]',0,'Virtual functions enable runtime polymorphism.',NULL,1),
('50000002-0000-0000-0000-000000000006','50000001-0000-0000-0000-000000000008','What is the purpose of a destructor?','["Clean up resources when an object is destroyed", "Create a new object", "Copy an object", "Initialize fields"]',0,'The destructor (~ClassName) is called when an object is destroyed.',NULL,2),
('50000002-0000-0000-0000-000000000007','50000001-0000-0000-0000-000000000008','Which access specifier hides members inside the class only?','["private", "public", "protected", "internal"]',0,'private members are only accessible within the class itself.',NULL,3),
('50000002-0000-0000-0000-000000000008','50000001-0000-0000-0000-000000000008','What does the override keyword do?','["Explicitly marks a virtual function override", "Creates a new virtual function", "Makes a function final", "Hides the base function"]',0,'override (C++11) ensures you are actually overriding a virtual function.',NULL,4),
('50000002-0000-0000-0000-000000000009','50000001-0000-0000-0000-000000000013','How do you add an element to the end of a vector?','["v.push_back(x)", "v.add(x)", "v.append(x)", "v.insert(x)"]',0,'push_back() adds an element to the end of a vector.',NULL,1),
('50000002-0000-0000-0000-000000000010','50000001-0000-0000-0000-000000000013','What is the time complexity of std::map lookup?','["O(log n)", "O(1)", "O(n)", "O(n log n)"]',0,'std::map is a balanced BST with O(log n) lookups.',NULL,2),
('50000002-0000-0000-0000-000000000011','50000001-0000-0000-0000-000000000013','What does std::sort require?','["Iterator range: sort(begin, end)", "Just the container", "Size and comparator", "Two pointers"]',0,'std::sort takes begin and end iterators: sort(v.begin(), v.end()).',NULL,3),
('50000002-0000-0000-0000-000000000012','50000001-0000-0000-0000-000000000013','What container prevents duplicates and keeps elements sorted?','["std::set", "std::vector", "std::list", "std::deque"]',0,'std::set stores unique elements in sorted order.',NULL,4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question,options=EXCLUDED.options,correct_option_index=EXCLUDED.correct_option_index;

INSERT INTO coding_challenges (id,lesson_id,title,description,starter_code,solution_code,language_id,hints,time_limit_seconds,memory_limit_mb,is_active) VALUES
('50000003-0000-0000-0000-000000000001','50000001-0000-0000-0000-000000000004','Swap Without Temp','Swap two integers using pointers with no temporary variable.','#include <iostream>
using namespace std;

void swapPointers(int* a, int* b) {
    // No temp variable!
}

int main() {
    int x = 10, y = 20;
    swapPointers(&x, &y);
    cout << x << " " << y << endl;  // 20 10
    return 0;
}','#include <iostream>
using namespace std;

void swapPointers(int* a, int* b) {
    *a = *a ^ *b;
    *b = *a ^ *b;
    *a = *a ^ *b;
}

int main() {
    int x = 10, y = 20;
    swapPointers(&x, &y);
    cout << x << " " << y << endl;
    return 0;
}','cpp','["Use XOR: a^=b; b^=a; a^=b;", "Or arithmetic: a=a+b; b=a-b; a=a-b;", "Dereference pointers with *a and *b"]',60,64,true),
('50000003-0000-0000-0000-000000000002','50000001-0000-0000-0000-000000000009','Virtual Animal','Create abstract Animal with virtual speak(). Implement Dog and Cat.','#include <iostream>
using namespace std;

class Animal {
protected:
    string name;
public:
    Animal(string name) : name(name) {}
    virtual void speak() = 0;
    virtual ~Animal() {}
};

// Add Dog class
// Add Cat class

int main() {
    Animal* a[] = { new Dog("Rex"), new Cat("Whiskers") };
    for (auto x : a) { x->speak(); delete x; }
    return 0;
}','#include <iostream>
using namespace std;

class Animal {
protected:
    string name;
public:
    Animal(string name) : name(name) {}
    virtual void speak() = 0;
    virtual ~Animal() {}
};

class Dog : public Animal {
public:
    Dog(string name) : Animal(name) {}
    void speak() override { cout << name << " says: Woof!" << endl; }
};

class Cat : public Animal {
public:
    Cat(string name) : Animal(name) {}
    void speak() override { cout << name << " says: Meow!" << endl; }
};

int main() {
    Animal* a[] = { new Dog("Rex"), new Cat("Whiskers") };
    for (auto x : a) { x->speak(); delete x; }
    return 0;
}','cpp','["Use = 0 to make speak() pure virtual", "Use : public Animal in child classes", "Use override keyword on child methods"]',90,64,true),
('50000003-0000-0000-0000-000000000003','50000001-0000-0000-0000-000000000014','Two Sum','Return indices of two numbers that add up to target using unordered_map.','#include <iostream>
#include <vector>
#include <unordered_map>
using namespace std;

vector<int> twoSum(vector<int>& nums, int target) {
    // O(n) solution
    return {};
}

int main() {
    vector<int> nums = {2, 7, 11, 15};
    auto r = twoSum(nums, 9);
    cout << r[0] << ", " << r[1] << endl;  // 0, 1
    return 0;
}','#include <iostream>
#include <vector>
#include <unordered_map>
using namespace std;

vector<int> twoSum(vector<int>& nums, int target) {
    unordered_map<int, int> seen;
    for (int i = 0; i < (int)nums.size(); i++) {
        int complement = target - nums[i];
        if (seen.count(complement)) return {seen[complement], i};
        seen[nums[i]] = i;
    }
    return {};
}

int main() {
    vector<int> nums = {2, 7, 11, 15};
    auto r = twoSum(nums, 9);
    cout << r[0] << ", " << r[1] << endl;
    return 0;
}','cpp','["Use unordered_map to store value to index", "For each number check if target minus num exists", "Add current number to map if not found"]',60,64,true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,description=EXCLUDED.description,is_active=EXCLUDED.is_active;

INSERT INTO chapters (id,language_id,title,description,order_index,icon_emoji,is_active) VALUES
('60000000-0000-0000-0000-000000000001','c','C Basics','The foundation of all programming',1,'🔧',true),
('60000000-0000-0000-0000-000000000002','c','Arrays & Strings','Memory, arrays, and C strings',2,'📝',true),
('60000000-0000-0000-0000-000000000003','c','Pointers & Memory','Dynamic memory and pointer arithmetic',3,'🧠',true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,description=EXCLUDED.description,is_active=EXCLUDED.is_active;

INSERT INTO lessons (id,chapter_id,language_id,title,description,type,difficulty,order_index,xp_reward,coin_reward,content,tags,estimated_minutes,is_active) VALUES
('60000001-0000-0000-0000-000000000001','60000000-0000-0000-0000-000000000001','c','Hello C World','The language that built the internet','theory','beginner',1,30,10,'# Hello C World

C is the mother of all languages. Linux, Python, and most operating systems are written in C.

## Your First C Program
```c
#include <stdio.h>

int main() {
    printf("Hello, CodeQuest!\n");
    return 0;
}
```

## Variables & Types
```c
int level = 5;
float xp = 1250.5f;
double pi = 3.14159265;
char grade = ''A'';
int isActive = 1;
```

## Printf Format Specifiers
```c
printf("%d\n", 42);
printf("%.2f\n", 3.14f);
printf("%c\n", ''X'');
printf("%s\n", "hello");
```','{"c","basics","printf","hello-world"}',10,true),
('60000001-0000-0000-0000-000000000002','60000000-0000-0000-0000-000000000001','c','Functions in C','Modular programming in C','theory','beginner',2,40,15,'# Functions in C

## Defining Functions
```c
int add(int a, int b) {
    return a + b;
}

int main() {
    int result = add(3, 7);
    printf("Result: %d\n", result);
    return 0;
}
```

## Pass by Pointer
```c
void doubleVal(int n) { n *= 2; }
void doublePtr(int* n) { *n *= 2; }

int x = 5;
doublePtr(&x);   // x is now 10
```

## Recursion
```c
int factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}
```','{"c","functions","recursion","pass-by-pointer"}',12,true),
('60000001-0000-0000-0000-000000000003','60000000-0000-0000-0000-000000000001','c','C Basics Quiz','Test your C foundations','quiz','beginner',3,50,20,'# C Basics Quiz','{"c","quiz","basics"}',5,true),
('60000001-0000-0000-0000-000000000004','60000000-0000-0000-0000-000000000001','c','Factorial Challenge','Compute factorial recursively','coding','beginner',4,80,35,'# Factorial Challenge','{"c","challenge","recursion"}',15,true),
('60000001-0000-0000-0000-000000000005','60000000-0000-0000-0000-000000000001','c','C Foundations Boss','Defeat the Segfault Specter!','boss_battle','intermediate',5,160,65,'# Boss Battle: The Segfault Specter','{"c","boss","basics"}',25,true),
('60000001-0000-0000-0000-000000000006','60000000-0000-0000-0000-000000000002','c','Arrays in C','Fixed-size sequential storage','theory','beginner',1,40,15,'# Arrays in C

```c
int scores[5] = {90, 75, 88, 92, 65};
int zeros[10] = {0};

printf("%d\n", scores[0]);
scores[2] = 100;

int len = sizeof(scores) / sizeof(scores[0]);

int max = scores[0];
for (int i = 1; i < len; i++) {
    if (scores[i] > max) max = scores[i];
}

int matrix[3][3] = {{1,2,3},{4,5,6},{7,8,9}};
printf("%d\n", matrix[1][2]);  // 6
```','{"c","arrays","2d-arrays"}',12,true),
('60000001-0000-0000-0000-000000000007','60000000-0000-0000-0000-000000000002','c','Strings in C','Character arrays and string functions','theory','beginner',2,45,18,'# Strings in C

C strings are null-terminated character arrays.

```c
#include <string.h>

char name[] = "Gokul";
printf("%c\n", name[0]);   // G
int len = strlen(name);    // 5

char s1[50] = "Hello, ";
char s2[] = "World!";
strcat(s1, s2);
strcpy(s1, "New");
int cmp = strcmp("abc","abc");  // 0 = equal

char input[100];
fgets(input, 100, stdin);
```','{"c","strings","char-array","string.h"}',12,true),
('60000001-0000-0000-0000-000000000008','60000000-0000-0000-0000-000000000002','c','Arrays & Strings Quiz','Test your arrays knowledge','quiz','beginner',3,55,22,'# Arrays & Strings Quiz','{"c","quiz","arrays","strings"}',5,true),
('60000001-0000-0000-0000-000000000009','60000000-0000-0000-0000-000000000002','c','String Reverser','Reverse a string in place','coding','intermediate',4,90,38,'# String Reverser Challenge','{"c","challenge","strings","pointers"}',20,true),
('60000001-0000-0000-0000-000000000010','60000000-0000-0000-0000-000000000002','c','Array Boss','The Array Overlord!','boss_battle','intermediate',5,180,70,'# Boss Battle: The Array Overlord','{"c","boss","arrays"}',25,true),
('60000001-0000-0000-0000-000000000011','60000000-0000-0000-0000-000000000003','c','Pointer Arithmetic','Navigate memory with pointers','theory','intermediate',1,50,20,'# Pointer Arithmetic

```c
int arr[] = {10, 20, 30, 40, 50};
int* p = arr;

printf("%d\n", *p);      // 10
printf("%d\n", *(p+1));  // 20
printf("%d\n", *(p+4));  // 50

p++;
printf("%d\n", *p);  // 20
```

## Function Pointers
```c
int add(int a, int b) { return a + b; }
int mul(int a, int b) { return a * b; }

int (*op)(int, int) = add;
printf("%d\n", op(3, 4));   // 7
op = mul;
printf("%d\n", op(3, 4));   // 12
```','{"c","pointers","pointer-arithmetic","memory"}',14,true),
('60000001-0000-0000-0000-000000000012','60000000-0000-0000-0000-000000000003','c','Dynamic Memory','malloc, calloc, free','theory','intermediate',2,55,22,'# Dynamic Memory Allocation

```c
#include <stdlib.h>

int* arr = (int*)malloc(5 * sizeof(int));
if (arr == NULL) { printf("Failed!\n"); return 1; }

for (int i = 0; i < 5; i++) arr[i] = i * 10;
free(arr);
arr = NULL;

int* nums = (int*)calloc(10, sizeof(int));
free(nums);

int* data = (int*)malloc(5 * sizeof(int));
data = (int*)realloc(data, 10 * sizeof(int));
free(data);
```','{"c","malloc","free","dynamic-memory"}',16,true),
('60000001-0000-0000-0000-000000000013','60000000-0000-0000-0000-000000000003','c','Pointers Quiz','Test your pointer mastery','quiz','intermediate',3,60,25,'# C Pointers Quiz','{"c","quiz","pointers","memory"}',5,true),
('60000001-0000-0000-0000-000000000014','60000000-0000-0000-0000-000000000003','c','Dynamic Array','Build a dynamic array with malloc','coding','intermediate',4,110,45,'# Dynamic Array Challenge','{"c","challenge","malloc","dynamic"}',20,true),
('60000001-0000-0000-0000-000000000015','60000000-0000-0000-0000-000000000003','c','Memory Allocator Boss','Final C Boss!','boss_battle','advanced',5,220,90,'# Boss Battle: The Memory Allocator','{"c","boss","pointers","memory"}',30,true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,content=EXCLUDED.content,is_active=EXCLUDED.is_active;

INSERT INTO quiz_questions (id,lesson_id,question,options,correct_option_index,explanation,code_snippet,order_index) VALUES
('60000002-0000-0000-0000-000000000001','60000001-0000-0000-0000-000000000003','What header is required for printf()?','["<stdio.h>", "<stdlib.h>", "<string.h>", "<math.h>"]',0,'<stdio.h> is the Standard Input/Output header.',NULL,1),
('60000002-0000-0000-0000-000000000002','60000001-0000-0000-0000-000000000003','What format specifier prints a float?','["%f", "%d", "%s", "%c"]',0,'%f prints a float or double.',NULL,2),
('60000002-0000-0000-0000-000000000003','60000001-0000-0000-0000-000000000003','What does a C function declared as void return?','["Nothing", "0", "NULL", "undefined"]',0,'void means the function returns no value.',NULL,3),
('60000002-0000-0000-0000-000000000004','60000001-0000-0000-0000-000000000003','What is the entry point of every C program?','["main()", "start()", "run()", "init()"]',0,'Every C program must have a main() function.',NULL,4),
('60000002-0000-0000-0000-000000000005','60000001-0000-0000-0000-000000000008','How do you find the length of a C array?','["sizeof(arr) / sizeof(arr[0])", "arr.length", "strlen(arr)", "len(arr)"]',0,'C has no built-in array length. sizeof / element size gives the count.',NULL,1),
('60000002-0000-0000-0000-000000000006','60000001-0000-0000-0000-000000000008','What terminates a C string?','["Null character \\0", "Space character", "-1", "NULL pointer"]',0,'C strings are null-terminated with \0 (ASCII 0).',NULL,2),
('60000002-0000-0000-0000-000000000007','60000001-0000-0000-0000-000000000008','What does strcpy() do?','["Copies one string into another", "Compares two strings", "Concatenates strings", "Returns string length"]',0,'strcpy(dest, src) copies src into dest.',NULL,3),
('60000002-0000-0000-0000-000000000008','60000001-0000-0000-0000-000000000008','What is the last valid index in int arr[5]?','["4", "5", "0", "3"]',0,'A 5-element array has indices 0 to 4. arr[5] is out-of-bounds!',NULL,4),
('60000002-0000-0000-0000-000000000009','60000001-0000-0000-0000-000000000013','What does malloc() return on failure?','["NULL", "0", "-1", "undefined"]',0,'malloc() returns NULL if memory allocation fails.',NULL,1),
('60000002-0000-0000-0000-000000000010','60000001-0000-0000-0000-000000000013','What is a memory leak?','["Allocated memory that is never freed", "Accessing freed memory", "Stack overflow", "Null pointer dereference"]',0,'A memory leak occurs when malloc memory is never freed.',NULL,2),
('60000002-0000-0000-0000-000000000011','60000001-0000-0000-0000-000000000013','What does p++ do if p is a pointer to int?','["Moves p to point to the next int in memory", "Increments the int value by 1", "Moves p by 1 byte", "Creates a new pointer"]',0,'Pointer arithmetic is type-aware. p++ on int* moves by sizeof(int) bytes.',NULL,3),
('60000002-0000-0000-0000-000000000012','60000001-0000-0000-0000-000000000013','What function resizes a previously allocated block?','["realloc()", "malloc()", "resize()", "extend()"]',0,'realloc(ptr, newSize) resizes a block.',NULL,4)
ON CONFLICT (id) DO UPDATE SET question=EXCLUDED.question,options=EXCLUDED.options,correct_option_index=EXCLUDED.correct_option_index;

INSERT INTO coding_challenges (id,lesson_id,title,description,starter_code,solution_code,language_id,hints,time_limit_seconds,memory_limit_mb,is_active) VALUES
('60000003-0000-0000-0000-000000000001','60000001-0000-0000-0000-000000000004','Factorial','Write recursive factorial(n). factorial(5)=120.','#include <stdio.h>

int factorial(int n) {
    // Your recursive solution
}

int main() {
    printf("%d\n", factorial(5));   // 120
    printf("%d\n", factorial(10));  // 3628800
    return 0;
}','#include <stdio.h>

int factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}

int main() {
    printf("%d\n", factorial(5));
    printf("%d\n", factorial(10));
    return 0;
}','c','["Base case: factorial(0) = factorial(1) = 1", "Recursive case: n * factorial(n-1)", "Add if statement for the base case"]',30,64,true),
('60000003-0000-0000-0000-000000000002','60000001-0000-0000-0000-000000000009','Reverse String','Reverse a string in place using two pointers.','#include <stdio.h>
#include <string.h>

void reverseString(char* str) {
    // Reverse in place
}

int main() {
    char s[] = "CodeQuest";
    reverseString(s);
    printf("%s\n", s);   // tseuQedoC
    return 0;
}','#include <stdio.h>
#include <string.h>

void reverseString(char* str) {
    int left = 0, right = strlen(str) - 1;
    while (left < right) {
        char temp = str[left];
        str[left] = str[right];
        str[right] = temp;
        left++; right--;
    }
}

int main() {
    char s[] = "CodeQuest";
    reverseString(s);
    printf("%s\n", s);
    return 0;
}','c','["Use two indices: left=0 and right=len-1", "Swap characters at left and right", "Move left forward and right backward until they meet"]',60,64,true),
('60000003-0000-0000-0000-000000000003','60000001-0000-0000-0000-000000000014','Dynamic Int Array','makeArray(n) allocates n ints filled with 1..n.','#include <stdio.h>
#include <stdlib.h>

int* makeArray(int n) {
    // Allocate n ints, fill with 1..n
}

int main() {
    int* arr = makeArray(5);
    for (int i = 0; i < 5; i++) printf("%d ", arr[i]);
    printf("\n");   // 1 2 3 4 5
    free(arr);
    return 0;
}','#include <stdio.h>
#include <stdlib.h>

int* makeArray(int n) {
    int* arr = (int*)malloc(n * sizeof(int));
    if (arr == NULL) return NULL;
    for (int i = 0; i < n; i++) arr[i] = i + 1;
    return arr;
}

int main() {
    int* arr = makeArray(5);
    for (int i = 0; i < 5; i++) printf("%d ", arr[i]);
    printf("\n");
    free(arr);
    return 0;
}','c','["Use malloc(n * sizeof(int)) to allocate", "Check if malloc returned NULL", "Fill with arr[i] = i + 1 in a loop", "Return the pointer"]',60,64,true)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,description=EXCLUDED.description,is_active=EXCLUDED.is_active;
