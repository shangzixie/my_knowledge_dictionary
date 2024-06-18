# ini

## ini.Empty()

using ini.empty(), its section not is null

```go
    f := ini.Empty()
    sections := f.Sections()
    for _, section := range sections {
        fmt.Println(section.Name())
    }
```

output is

```go
DEFAULT
```
