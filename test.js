
// event dp[x] = dp[x- 2] + 2
/*
dp[m] = min(dp[q] + q, d[w] + w)
i: a, b, c

m: i + a = m , dp[m] = min(dp[i] + 1 , ... )
  dp[m + a] = min(dp[m] + 1, dp[m+a])

m - i = set(a)

m set= {a, b, c} -> m + a,  m + c, m + c
map = {m+a: m}

m + a, min(dp[v1]+ 1, +dp[v2] + 1)

m, set(a, b, c),       m + a | m+b | m+c
map { m + a: m, m + b: m...}

dp[m+a] = min(dp[m] + 1, ...) O(n)
4 3

*/

var solution = function(i, j) {
  if (i == j) return 0;
  let dp = new Array(i * 2 + 1);
  dp[i] = 0;

  if (i >= j) {
    for (let )
  }
  for (int m)
}


var get

// x