# array vs slice

- [array vs slice](#array-vs-slice)
  - [Array VS Slice](#array-vs-slice-1)
  - [Array](#array)
    - [build an array](#build-an-array)
    - [not reference type](#not-reference-type)
    - [compare](#compare)
  - [slice](#slice)
    - [A slice contains three components](#a-slice-contains-three-components)
    - [build an slice](#build-an-slice)
    - [nil slice](#nil-slice)
    - [slice reference  array](#slice-reference--array)
    - [切片的传递](#切片的传递)
    - [compare](#compare-1)
    - [slice扩容](#slice扩容)
  - [reference](#reference)


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
 var arr [2][3]int
array1 := [2][]int{[]int{1},[]int{2}}  // array1 is an array and its item is a slice
array2 := [2][]int{{1}, {2}} // array2 is an array and its item is a slice
array3 := [2][3]int{
        {1, 2, 3},
        {4, 5, 6},
    }  // array3 is an array and its item is an array
array4 := [2][3]int{} // array4 is an array and its item is an array
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
slice3 := make([][]int, rows)
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

slice的基本结构, 底层也是一个数组

```golang
type SliceHeader struct {
   Data uintptr // 底层数组的指针
   Len  int     // 切片的长度
   Cap  int     // 切片的容量
}
```

change some elements in the slice, then the changes should also take place in the referenced array. 这里因为slice的底层数组是基于array的, 所以slice的修改会影响到array的值.

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

### 切片的传递

```golang
// foo 尝试把数组的第一个元素修改为9
func foo(arr [3]int) {
    arr[0] = 9
}

// bar 尝试把切片的第一个元素修改为9
func bar(slice []int) {
    slice[0] = 9
}

func main() {
    arr := [3]int{1, 2, 3}
    slice := []int{1, 2, 3}
    foo(arr)           // 尝试修改数组
    bar(slice)         // 尝试修改切片
    fmt.Println(arr)   // [1 2 3]
    fmt.Println(slice) // [9 2 3]
}
```

我们对arr的修改在main函数中是不可见的，这符合我们刚刚提到的:一切参数的传递都是值传递，我们在foo中修改的只是arr的一个副本，真正的arr并没有被修改，除非我们将foo函数的参数修改为指针类型。但slice的修改却影响到了main函数中的slice,这是为什么呢？难道切片是引用传递而非值传递吗？

其实不是的，我们上面说了，一切参数传递都是值传递，slice当然也不例外 ，结合我们刚刚了解的slice的结构，我们在向bar中传递参数时，是将slice的结构体拷贝了一份而并非拷贝了底层数组本身，因为slice的结构体内持有底层数组的指针，所以在bar内修改slice的数据会将底层数组的数据修改，从而影响到main函数中的slice。

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

### slice扩容

切片在运行时的表示为reflect.SliceHeader，其结构如下

```golang
type SliceHeader struct {
   Data uintptr // 底层数组的指针
   Len  int     // 切片的长度
   Cap  int     // 切片的容量
}
```

slice扩容时会调用`runtime.growslice`函数. 假设一个slice初始cap容量为3, 已经有3个元素, 所以长度为3. 现在往里面append一个数, 我们向`growslice`函数传入的cap就为4, 这个cap是期望容量. 但是扩容后的容量并不是按照期望容量来的, 扩容后的容量是按照以下规则来的:

* 如果期望容量大于当前容量的两倍就会使用期望容量；
* 如果当前切片的长度小于 1024 就会将容量翻倍；
* 如果当前切片的长度大于 1024 就会每次增加 25% 的容量，直到新容量大于期望容量；

在 Go 语言中，当切片需要扩容时，实际的机制是创建一个新的、更大的底层数组，并将旧切片的数据复制到新的数组中。这意味着旧的切片不会被直接修改，而是会被复制到新的底层数组中。

```golang
func growslice(et *_type, old slice, cap int) slice {
    // 省略了部分代码
    newcap := old.cap
    // doublecap为旧切片容量的2倍
    doublecap := newcap + newcap
    // 如果期望容量 > doublecap,则直接将期望容量作为新的容量
    if cap > doublecap {
        newcap = cap
    } else {
        // 判断旧切片的容量，如果小于1024，则将旧切片的容量翻倍
        if old.cap < 1024 {
            newcap = doublecap
        } else {
            // 每次增长1/4,直到容量大于期望容量
            for 0 < newcap && newcap < cap {
                newcap += newcap / 4
            }
            // 如果旧切片容量小于等于0，则直接将期望容量作为新容量
            if newcap <= 0 {
                newcap = cap
            }
        }
    }
    // 省略了部分代码
}

```

## reference

[link 1](https://juejin.cn/post/7136774425415794719)
[link 2](https://mp.weixin.qq.com/s/vIX5NHtDTaqAu2WVUwn6WA)