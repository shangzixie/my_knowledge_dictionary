// n m, array.length = n;
// arr is integer
// sum( arr[i] + ... + arr[j]) <= m
// return [i, j]

// [1, 1, 1] m = 2
// [1, 1, 1] m = 3;

// [10, 1]  m = 5;
// [1 ,1] m = 0;
// [0],  m = 0

var solution = function(arr, m, n) {
  if (arr.length === 0) return null;
  if (arr.length === 1) return arr[0] <= m ? [0, 0] : null;

  let left = 0;
  let right = 0;
  let sum = arr[0];
  let result = [left, right];
  let maxSum = 0;

  // get max sum, sum <= m
  while (right < n && sum <= m) {
    if (right != left) sum += arr[right];
    right += 1;
  }

  maxSum = right === n ? sum : sum - arr[right - 1];
  result = [left, right - 1];

  // [10 , 1, 1] m = 2
  //      ||
  // init: sum > m
  while (left < arr.length && right < arr.length) {
    // move left
    while (left < right && sum > m) {
      sum -= arr[left];
      left += 1;
      // maintain maxSum, update result
      if (sum > maxSum && sum <= m) {
        maxSum = sum;
        result = [left, right];
        if (sum === m) return result;
      }
    }

    if (left === right) sum = arr[left];
    // sum <= m
    while (right < arr.length && sum <= m) {
      right += 1;
      sum += arr[right];
      if (sum > maxSum && sum <= m) {
        maxSum = sum;
        result = [left, right];
      }
    }
  }

  if (maxSum === 0) return null;
  return result;
}
