# load

```go
 confFile := filepath.Join("/Users/xshangzi/projects/go_playground", "app.conf")
 // 大小写敏感
 cfg, err := ini.Load(confFile)
 if err != nil {
  fmt.Println("Fail to read file: %v", err)
  return
 }
 httpsEnabled, err := cfg.Section("").Key("EnableHTTPS").Bool();
 fmt.Println(httpsEnabled)
```
