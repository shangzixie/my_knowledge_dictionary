# How to use slice capacity and length in Go

```golang
vals := make([]int, 5)
for i := 0; i < 5; i++ {
  vals = append(vals, i)
}
fmt.Println(vals)
```

If you guessed [0 0 0 0 0 0 1 2 3 4] you are correct.

Wait, what? Why isn't it [0 1 2 3 4]?

Don't worry if you got the pop quiz wrong. This is a fairly common mistake when transitioning into Go and in this post we are going to cover both why the output isn't what you expected along with how to utilize the nuances of Go to make your code more efficient.


## reference

[blog](https://www.calhoun.io/how-to-use-slice-capacity-and-length-in-go/)