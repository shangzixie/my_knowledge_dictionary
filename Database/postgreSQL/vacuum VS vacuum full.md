# vacuum VS vacuum full

## vacuum

vacuum不会压缩空间, 只是把那些标注为dead的tuple进行重新收集, 变为available的tuple, 但是这些tuple的空间并没有被释放, 也就是说, 空间并没有被压缩.

## vacuum full

它会锁住表, 然后创建新的区域把数据复制过去, 然后删除旧的数据, 这样就会压缩空间, 把一些dead tuple的空间释放出来.


## reference

[stackOverFlow](https://dba.stackexchange.com/questions/56374/vacuum-freeze-vs-vacuum-full)