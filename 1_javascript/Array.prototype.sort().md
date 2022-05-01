# 不是传统那种sort!!!

The `sort()` method sorts the elements of an array in place and returns the sorted array. The default sort order is ascending, built upon converting the elements into `strings`, then comparing their sequences of `UTF-16 code` units values.

The time and space complexity of the sort cannot be guaranteed as it depends on the implementation.

## 如何sort by integer

[link](https://stackoverflow.com/questions/1063007/how-to-sort-an-array-of-integers-correctly)

```javascript
var numArray = [140000, 104, 99];
numArray.sort(function(a, b) {
  return a - b;
});
```
