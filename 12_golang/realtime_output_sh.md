# print realtime output log using golang to run sh

```go

package main

import (
 "bufio"
 "fmt"
 "os/exec"
)

func main() {
 cmd := exec.Command("bash", "./run.sh")
 stdout, _ := cmd.StdoutPipe()
 if err := cmd.Start(); err != nil {
  fmt.Printf("err: %s", err)
 }

    scanner := bufio.NewScanner(stdout)
    for scanner.Scan() {
        m := scanner.Text()
        fmt.Println(m)
    }

    cmd.Wait()
}
```
