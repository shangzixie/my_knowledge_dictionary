# struct

## new a struct

```go
 type Address struct {
      name string
      street string
      city string
      state string
      Pincode int
}

var a = Address{"Akshay", "PremNagar", "Dehradun", "Uttarakhand", 252636}
var a = Address{Name: "Akshay", street: "PremNagar", state:"Uttarakhand", Pincode: 252636}
```

* use pointer

```go
func main() {
    // passing the address of struct variable
    // emp8 is a pointer to the Employee struct
    emp8 := &Employee{"Sam", "Anderson", 55, 6000}

    // (*emp8).firstName is the syntax to access
    // the firstName field of the emp8 struct
    fmt.Println("First Name:", (*emp8).firstName)
    fmt.Println("Age:", (*emp8).age)
}
```
