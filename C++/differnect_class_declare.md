# class declare

1. `Author a;`

it is in `stack` memory. This default constructor.

1. `Author a = Author();`

it is in `stack` memory. it's default constructor

![2](/Image/C++/2.png)

Copy Elision:

Modern C++ compilers optimize this pattern with copy elision, so the temporary is usually optimized away, making it effectively equivalent to direct initialization.

3. `Author* a = new Author();`

The expression new Author() dynamically allocates an Author object on the heap and returns a pointer to it (i.e., its type is Author*).
