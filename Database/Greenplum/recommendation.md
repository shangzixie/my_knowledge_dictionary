# gpcc recommendation

## Bloat

heap表的bloat是指表中的数据和索引占用的空间和实际数据量之间的差距。bloat值越大，表的性能就越差。bloat值越小，表的性能就越好。一般pg更新数据是通过插入新数据的方式, 那么原数据就会越来越多造成膨胀. 需要用到`VACUUM FULL`来清理膨胀的数据.

## Accuracy

数据库表的有一些元数据, 例如行数, 表尺寸, 以及一些index的统计, 当有重大改变时候就会不准. 这时候就要用`ANALYZE`来更新元数据. 所以gpcc会统计不准确率, 通过查询计划拿到的老统计数据和全表扫描的结果进行比较. gpcc可以通过schedule来定期扫描全表, 设定一个时长, 如果没扫描完, 下次会优先扫描未扫描的表

## Skew

数据倾斜, 表示某表数据在一些机器上比另一些机器多多少.

Skew%是介于 0% 和 100% 之间的值（含）。值越高，表的分布越不均匀。假设表 `T` 分布在n个段中，`S_1_` 是段1上的元组数量，`S_n_` 是段n上的元组数量：

```
Avg = (S1 + S2 + ... Sn) / n
Max = MAX(S1, S2, ... Sn)
Skew% = (1 - Avg / Max) / (1 - 1/n) * 100%
```

## reference

[link](https://docs.vmware.com/en/VMware-Greenplum-Command-Center/7.1/greenplum-command-center/topics-ui-recommendations.html#bloat)