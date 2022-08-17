# dlv

```
this could be caused by a kernel security setting, try writing "0" to /proc/sys/kernel/yama/ptrace_scope
```
try this:

```shell
sudo sysctl -w kernel.yama.ptrace_scope=0
```