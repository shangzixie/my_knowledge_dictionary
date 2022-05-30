# slice

## A slice contains three components

Pointer: The pointer is used to points to the first element of the array that is accessible through the slice. Here, it is not necessary that the pointed element is the first element of the array.
Length: The length is the total number of elements present in the array.
Capacity: The capacity represents the maximum size up to which it can expand.

## build an slice

```golang
[]T

[]T{}

[]T{value1, value2, value3, ...value n}

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
```

## nil slile

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

## slice reference  array

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

## compare

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
