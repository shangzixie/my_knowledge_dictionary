# golang template package

```go
package main

import (
    "os"
    "text/template"
)

type Todo struct {
    Name        string
    Description string
}

func main() {
    td := Todo{"Test templates", "Let's test a template to see the magic."}

    t, err := template.New("todos").Parse("You have a task named \"{{ .Name}}\" with description: \"{{ .Description}}\"")
    if err != nil {
        panic(err)
    }
    err = t.Execute(os.Stdout, td)
    if err != nil {
        panic(err)
    }
}
```

## reference

[blog](https://blog.gopheracademy.com/advent-2017/using-go-templates/)
