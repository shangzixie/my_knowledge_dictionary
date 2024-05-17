# omitempty

```golang
type fruit struct {
  Name   string
  Length int    `json:,omitempty`
}
```

`json:,omitempty` is a json tag for a field in a struct. When unmarshalling json data into a struct, if that particular field is empty, the field would be ignored. Without the omitempty tag, a default value will be used.

In the example above, without the omitempty tag, the length field would be populated with the int 0. If the type of the empty field is string, `""` (empty string) would be the default value. Similarly, the default value of a boolean type is false and nil for pointer, interface, slice and map.
