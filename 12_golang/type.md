# Different Ways to Find the Type of Variable in Golang

* Using `reflect.TypeOf` Function
* Using `reflect.ValueOf.Kind()` Function
* Using `%T` with Printf

```golang
fmt.Printf("var1 = %T\n", var1)
reflect.TypeOf(var1)
reflect.ValueOf(var1).Kind()
```
