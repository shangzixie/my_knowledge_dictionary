# Lock

`Lock()`: only one go routine read/write at a time by acquiring the lock.

`RLock()`: multiple go routine can read(not write) at a time by acquiring the lock

```
1. When a go-routine has already acquired a RLock(), can another go-routine acquire a Lock() for write or it has to wait until RUnlock() happens?

To acquire a Lock() for write it has to wait until RUnlock()

2. What happens when someone already acquired Lock() for map ,will other go-routine can still get RLock()

if someone X already acquired Lock(), then other go-routine to get RLock() will have to wait until X release lock (Unlock())

3. Assuming we are dealing with Maps here, is there any possibility of "concurrent read/write of Map" error can come?

Map is not thread safe. so "concurrent read/write of Map" can cause error.
```

## reference

[stack overflow](https://stackoverflow.com/questions/53427824/what-is-the-difference-between-rlock-and-lock-in-golang)
