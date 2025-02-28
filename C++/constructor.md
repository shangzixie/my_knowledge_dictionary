# constructor in C++

## default constructor

Default initialization occurs when an object is declared without providing `explicit` initial values.

1. Since MyClass does not define a constructor, the value member remains uninitialized, which leads to undefined behavior (it may contain garbage values).

```cpp
class MyClass {
public:
    int value; // Not explicitly initialized
};

MyClass obj;
```

2. Since `MyClass` defines a default constructor, when `obj` is default-initialized, the constructor assigns value = 10.

```cpp
class MyClass {
public:
    int value;
    MyClass() : value(10) {}
};


class MyClass {
public:
    int value = 10; // Default member initializer (C++11+)
};

class MyClass {
public:
    int value;
    MyClass() { value = 10; } // Default constructor initializes `value`
};

class MyClass {
public:
    static int staticValue; // Static members are always initialized to zero by default
};

MyClass obj; // Default initialization
```

## parameterized constructor

```cpp
class MyClass {
public:
    int value;
    // Parameterized constructor
    MyClass(int v) : value(v) {}
};

int main() {
    MyClass obj(25); // value is initialized to 25.
    return 0;
}

```

## in class initialization

```cpp
class MyClass {
public:
    int value = 10;  // In-class initializer: value is 10 by default.
};

int main() {
    MyClass obj1;  // value is 10.
    MyClass obj2{20};  // value is 20 if you provide a constructor (see next example).
    return 0;
}
```

## Aggregate Initialization

```cpp
struct MyStruct {
    int a;
    double b;
};

int main() {
    MyStruct s = {5, 3.14};  // a is 5, b is 3.14.
    return 0;
}

```

## Copy Initialization

```cpp
class MyClass {
public:
    int value;

    // Default constructor.
    MyClass() : value(10) {}

    // Copy constructor.
    MyClass(const MyClass& other) : value(other.value) {
        std::cout << "Copy constructor called." << std::endl;
    }
};

int main() {
    MyClass obj1;            // Default constructor is called.
    MyClass obj2 = obj1;     // Copy initialization: copy constructor is invoked.
    std::cout << "obj1.value: " << obj1.value << std::endl;
    std::cout << "obj2.value: " << obj2.value << std::endl;
    return 0;
}
```

The second line creates obj2 by copying the state of obj1. The compiler calls the copy constructor of MyClass to initialize obj2 with the contents of obj1.
C++ automatically generates a default copy constructor if you don’t define one yourself.

```cpp
#include <iostream>

class MyClass {
public:
    int value;

    // Default constructor
    MyClass() : value(10) {}
};

int main() {
    MyClass obj1;            // Default constructor initializes value to 10.
    MyClass obj2 = obj1;     // Default copy constructor performs member-wise copy.

    std::cout << "obj1.value: " << obj1.value << std::endl;  // Outputs: 10
    std::cout << "obj2.value: " << obj2.value << std::endl;  // Outputs: 10

    return 0;
}

```
