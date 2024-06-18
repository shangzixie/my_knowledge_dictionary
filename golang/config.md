# load

```config
enablehttps     = true
```

```go
 confFile := filepath.Join("/Users/xshangzi/projects/go_playground", "app.conf")
 // 大小写敏感
 cfg, err := ini.Load(confFile)
 if err != nil {
    fmt.Println("Fail to read file: %v", err)
    return
 }
    httpsEnabled1, err := cfg.Section("").Key("enablehttps").Bool();
    fmt.Println(httpsEnabled1)
    httpsEnabled2, err := cfg.Section("").Key("EnableHTTPS").Bool();
    fmt.Println(httpsEnabled2)
```

output:

`true, false`

```go
confFile := filepath.Join("/Users/xshangzi/projects/go_playground", "app.conf")
 // 大小写敏感
cfg, err := ini.Load(confFile)
if err != nil {
    fmt.Println("Fail to read file: %v", err)
    return
}
    httpsEnabled1, err := cfg.Section("").Key("enablehttps").Bool();
    fmt.Println(httpsEnabled1)
    httpsEnabled2, err := cfg.Section("").Key("EnableHTTPS").Bool();
    fmt.Println(httpsEnabled2)
```

output is `true, true`