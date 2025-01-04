# Twitter System Design

## 主页时间线

用户可以查阅他们关注的人发布的推文（300k 请求 / 秒）。

## 发布推文

用户可以向其粉丝发布新消息（平均 4.6k 请求 / 秒，峰值超过 12k 请求 / 秒）。

## design fan-out

There are two ways to implement fan-out:

1. user request timeline update -> find all the user's followees -> get all their tweets -> combine into timeline

![](/Image/system_design/97.png)

2. every user maintains a timeline cache -> a user post a tweet -> find all followers/fans of the user -> insert the tweet into their timeline cache

![](/Image/system_design/98.png)

because the user request timeline update request workload is 300k/s, and the request of the user post a tweet is 4.6k/s, so we choose the second way to implement fan-out.

然而方法 2 的缺点是，发推现在需要大量的额外工作。平均来说，一条推文会发往约 75 个关注者，所以每秒 4.6k 的发推写入，变成了对主页时间线缓存每秒 75 * 4.6k = 345k 的写入。但这个平均值隐藏了用户粉丝数差异巨大这一现实，一些用户有超过 3000 万的粉丝，这意味着一条推文就可能会导致主页时间线缓存的 3000 万次写入！及时完成这种操作是一个巨大的挑战 —— 推特尝试在 5 秒内向粉丝发送推文。

在推特的例子中，每个用户粉丝数的分布（可能按这些用户的发推频率来加权）是探讨可伸缩性的一个关键负载参数，因为它决定了fan-out负载。你的应用程序可能具有非常不同的特征，但可以采用相似的原则来考虑它的负载。

推特轶事的最终转折：现在已经稳健地实现了方法 2，推特逐步转向了两种方法的混合。大多数用户发的推文会被fan out写入其粉丝主页时间线缓存中。但是少数拥有海量粉丝的用户（即名流）会被排除在外。当用户读取主页时间线时，分别地获取出该用户所关注的每位名流的推文，再与用户的主页时间线缓存合并，如方法 1 所示。这种混合方法能始终如一地提供良好性能。

## reference

[reference link](https://github.com/shangzixie/ddia/blob/main/ch1.md)
