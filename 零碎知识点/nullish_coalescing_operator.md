# 空合并运算符(??)

## 形式

`var dValue = nValue ?? "defaultValue"`

如果`nValue`是`null`或者`undefined`， 则指派默认值`defaultValue`

## 和 || 的不同

```javascript

var bookType = book.Type || "PDF"; // Type is undefined so default is "PDF"

book.Version = 0;
var version = book.Version || 1; // 1

book.SubTitle = '';
var subTitle = book.SubTitle || "Angular Book"; // Angular Book

book.IsFreeBook = false;
var isFreeBook = book.IsFreeBook || true; // true
```

书的版本version为0是正常现象，subtitle没有也是正常可以接受的, 同样有些书是收费的，所以ifFreeBook为`false`

所以这里要用到`??`

```javascript
book.Version = 0;
var version = book.Version ?? 1; // 0

book.SubTitle = '';
var subTitle = book.SubTitle ?? "Angular Book"; // ''

book.IsFreeBook = false;
var isFreeBook = book.IsFreeBook ?? true; // false
```
