# array vs slice

## Array VS Slice

1. when using `make()`, it will create a slice, not an array.
2. array is value type, slice is reference type. when you pass an array to a function, it will copy the array, but when you pass a slice to a function, it will pass the reference of the slice.
3. memory:

   Arrays in Go are value types and are allocated where they are declared. If an array is declared as a local variable within a function, it is typically allocated on the stack. This is true unless the array is too large to fit efficiently on the stack or it escapes from the function (e.g., by being returned from the function or by being assigned to a variable that is accessible outside the function), in which case it can be allocated on the heap.

   Slices are reference types, and their behavior regarding memory allocation is slightly different:
    1. Slice Header: The slice itself (i.e., the slice header, which contains the pointer to the array, the length, and the capacity) is allocated where the slice is declared. If a slice is declared as a local variable within a function and does not escape the function, the slice header is typically allocated on the stack.
    2. Underlying Array: The data of the slice, which is the actual array that the slice points to, can be allocated on the heap. This is because the underlying array might need to grow dynamically, and its size is not necessarily known at compile time. The underlying array is where the actual elements of the slice are stored.

## Array

### build an array

```golang
// it is just declare a array, not initialize, the array_name is nil
var array_name [length]Type

// it is declare and initialize with length
array_name := [length]Type{item1, item2, item3,...itemN}

// it is declare and initialize without length
array_name := [...]string{"GFG", "gfg", "geeks", "GeeksforGeeks", "GEEK"}


// initialize a 2d array
array1 := [2][]int{[]int{1},[]int{2}}
array2 := [2][]int{{1}, {2}}
```

we can't build an array with a variable length, the length must be a constant.

```golang
buckets := [len(s) + 1][]byte{} // it's wrong
```

we just can use `make()` to create a slice with a variable length.

```golang
buckets := make(len(s) + 1, [][]byte) // it's right
```

why? 

### not reference type

In Go language, an array is of value type not of reference type.

```golang
// Go program to illustrate value type array
package main

import "fmt"

func main() {
    // Creating an array whose size
    // is represented by the ellipsis
    my_array:= [...]int{100, 200, 300, 400, 500}
    fmt.Println("Original array(Before):", my_array)

    // Creating a new variable
    // and initialize with my_array
    new_array := my_array

    fmt.Println("New array(before):", new_array)

    // Change the value at index 0 to 500
    new_array[0] = 500

    fmt.Println("New array(After):", new_array)

    fmt.Println("Original array(After):", my_array)
}
```

output:

```golang
Original array(Before): [100 200 300 400 500]
New array(before): [100 200 300 400 500]
New array(After): [500 200 300 400 500]
Original array(After): [100 200 300 400 500]
```

### compare

shallow compare:

```golang

// Go program to illustrate
// how to compare two arrays
package main

import "fmt"

func main() {
    // Arrays
    arr1:= [3]int{9,7,6}
    arr2:= [...]int{9,7,6}
    arr3:= [3]int{9,5,3}

    // Comparing arrays using == operator
    fmt.Println(arr1==arr2)
    fmt.Println(arr2==arr3)
    fmt.Println(arr1==arr3)

    // This will give and error because the
    // type of arr1 and arr4 is a mismatch
    /*
    arr4:= [4]int{9,7,6}
    fmt.Println(arr1==arr4)
    */
}
```



## slice

### A slice contains three components

Pointer: The pointer is used to points to the first element of the array that is accessible through the slice. Here, it is not necessary that the pointed element is the first element of the array.
Length: The length is the total number of elements present in the array.
Capacity: The capacity represents the maximum size up to which it can expand.

### build an slice

```golang
// this is declare a slice, not initialize, the slice_name is nil
var slice []T

// this is declare and initialize, the content is null
slice := []T{}

// this is declare and initialize with content
slice := []T{value1, value2, value3, ...value n}

// create slice by array
arr := [7]string{"This", "is", "the", "tutorial", "of", "Go", "language"}
myslice := arr[1:6]


// using the slice literal
// when you create a slice using a literal, then it first creates an array and after that return a slice reference to it.
var my_slice_1 = []string{"Geeks", "for", "Geeks"}

// Using make() function
var my_slice = make([]T, len, cap) []T
var my_slice_1 = make([]int, 4, 7) // [0 0 0 0]
var my_slice_2 = make([]int, 7) // [0 0 0 0 0 0 0], len and cap are 7

// initialize a 2d slice
slice1 := [][]int{[]int{1},[]int{2}}
slice2 := [][]int{{1}, {2}}
```

### nil slice

create a nil slice, capacity and the length of this slice is 0

```golang
func main() {
    // Creating a zero value slice
    var myslice []string
    fmt.Printf("Length = %d\n", len(myslice))
    fmt.Printf("Capacity = %d ", cap(myslice))

}
```

output:

```
Length = 0
Capacity = 0
```

### slice reference  array

change some elements in the slice, then the changes should also take place in the referenced array.

```golang
func main() {
    // Creating a zero value slice
    arr := [6]int{55, 66, 77, 88, 99, 22}
    slc := arr[0:4]

    // Before modifying

    fmt.Println("Original_Array: ", arr)
    fmt.Println("Original_Slice: ", slc)

    // After modification
    slc[0] = 100
    slc[1] = 1000
    slc[2] = 1000

    fmt.Println("\nNew_Array: ", arr)
    fmt.Println("New_Slice: ", slc)
}
```

```
Original_Array:  [55 66 77 88 99 22]
Original_Slice:  [55 66 77 88]

New_Array:  [100 1000 1000 88 99 22]
New_Slice:  [100 1000 1000 88]
```

### compare

`==` just use to compare with `nil`, If try to compare two slices with `==` then it will give an error

```golang
func main() {
    // creating slices
    s1 := []int{12, 34, 56}
    var s2 []int
    // If you try to run this commented
    // code compiler will give an error
    /*s3:= []int{23, 45, 66}
      fmt.Println(s1==s3)
    */

    // Checking if the given slice is nil or not
    fmt.Println(s1 == nil)
    fmt.Println(s2 == nil)
}
```

deep equal: `reflect.DeepEqual(x, y)`
there is no shallow euqal in slice
