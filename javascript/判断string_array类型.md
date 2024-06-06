# 如何判断一个数组的元素都是string

```typescript
function isStringArray(value: any): value is string[] {
    if (value instanceof Array) {
        for (const item of value) {
            if (typeof item !== 'string') return false;
        }
        return true;
    }
    return false;
}

function join<T>(value: string[] | T[]) {
  if (isStringArray(value)) {
    return value.join(',') // value is string[] here
  } else {
    return value.map((x) => x.toString()).join(',') // value is T[] here
  }
}
```