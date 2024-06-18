# dlv

## usage

* `ps aux | grep gpccws` to get the pid
* `dlv attach [pid]`
* if where are a error:
`this could be caused by a kernel security setting, try writing "0" to /proc/sys/kernel/yama/ptrace_scope`
try this out of container:
`sudo sysctl -w kernel.yama.ptrace_scope=0`
* add break point: `b backend/gpmonws/models/common.go:600`
* when you attach dlv, it will not run, so use `c`

## Q&A

### auth

```
this could be caused by a kernel security setting, try writing "0" to /proc/sys/kernel/yama/ptrace_scope
```
try this:

```shell
sudo sysctl -w kernel.yama.ptrace_scope=0
```

### not print full string

`config max-string-len 1000`
