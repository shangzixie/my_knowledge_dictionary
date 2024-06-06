# array in golang

## build an array

```golang
var array_name[length]Type

var array_name[length]Typle{item1, item2, item3, ...itemN}

array_name := [length]Type{item1, item2, item3,...itemN}

array_name := [...]string{"GFG", "gfg", "geeks", "GeeksforGeeks", "GEEK"}

```

## not reference type

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

## compare

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
