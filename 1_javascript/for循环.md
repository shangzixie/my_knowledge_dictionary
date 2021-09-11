
# for-loop in js

[link1](https://zhuanlan.zhihu.com/p/23812134)
[link2](https://zhuanlan.zhihu.com/p/58881052)

In JavaScript, `Array` also is a `object`. `Array` in js is a wrong name. Acutually, `Array` in memory is not contiguous, all index in array also is not a offset of memory. Index is a string type (object key). There is no `1`, `2` ... in js index, just `'1'`, `'2'` ...

## for-in

`for in`is not designed for array, but for `object`.

```javascript
const arr = [1, 2, 3];
arr.name = "Hello world";
let index;
for(index in arr) {
    console.log("arr[" + index + "] = " + arr[index]);
}
```

output:

```javascript
arr[0] = 1
arr[1] = 2
arr[2] = 3
arr[name] = Hello world
```

`for-in` also interate prototype link:

```javascript
Array.prototype.fatherName = "Father";
const arr = [1, 2, 3];
arr.name = "Hello world";
let index;
for(index in arr) {
    console.log("arr[" + index + "] = " + arr[index]);
}
```

output:

```javascript
arr[0] = 1
arr[1] = 2
arr[2] = 3
arr[name] = Hello world
arr[fatherName] = Father
```
