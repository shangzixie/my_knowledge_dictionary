# map

## new a map

* create nil map:

```go
func main() {
    // Creating and initializing empty map
    // Using var keyword
    var map_1 map[int]int
    // Checking if the map is nil or not
    fmt.Println(map_1 == nil) // true
```

* create map and initialize them with some data

```go
// Creating and initializing a map
// Using shorthand declaration and
// using map literals
map_2 := map[int]string{
    90: "Dog",
    91: "Cat",
    92: "Cow",
    93: "Bird",
    94: "Rabbit",
}
fmt.Println("Map-2: ", map_2)
```

* using make()

```go
make(map[Key_Type]Value_Type, initial_Capacity)
make(map[Key_Type]Value_Type)

func main() {
    // Creating a map
    // Using make() function
    var My_map = make(map[float64]string)
    fmt.Println(My_map)

    // As we already know that make() function
    // always returns a map which is initialized
    // So, we can add values in it
    My_map[1.3] = "Rohit"
    My_map[1.5] = "Sumit"
    fmt.Println(My_map)
}
```

## iterate map

```go
for key, value := my_map {

}
```

## add pair

```go
// Main function
func main() {
    // Creating and initializing a map
    m_a_p := map[int]string{
        90: "Dog",
        91: "Cat",
        92: "Cow",
        93: "Bird",
        94: "Rabbit",
    }

    // Adding new key-value pairs in the map
    m_a_p[95] = "Parrot"
}
```

## retrieve a value

```go
// Without value using the blank identifier
// It will only give check result
_, check_variable_name:= map_name[key]

fmt.Println(check_variable_name) // false
```

## delete pair

```go
delete(map_name, key)
```
