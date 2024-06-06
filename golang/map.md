# map

## new a map

* create nil map:

```go
func main() {
    // Creating and initializing empty map
    // Using var keyword
    var map_1 map[int]int
    // Checking if the map is nil or not
    fmt.Println(map_1 == nil) // true
```

* create map and initialize them with some data

```go
// Creating and initializing a map
// Using shorthand declaration and
// using map literals
map_2 := map[int]string{
    90: "Dog",
    91: "Cat",
    92: "Cow",
    93: "Bird",
    94: "Rabbit",
}
fmt.Println("Map-2: ", map_2)
```

* using make()

```go
make(map[Key_Type]Value_Type, initial_Capacity)
make(map[Key_Type]Value_Type)

func main() {
    // Creating a map
    // Using make() function
    var My_map = make(map[float64]string)
    fmt.Println(My_map)

    // As we already know that make() function
    // always returns a map which is initialized
    // So, we can add values in it
    My_map[1.3] = "Rohit"
    My_map[1.5] = "Sumit"
    fmt.Println(My_map)
}
```

## iterate map

```go
for key, value := my_map {

}
```

## add pair

```go
// Main function
func main() {
    // Creating and initializing a map
    m_a_p := map[int]string{
        90: "Dog",
        91: "Cat",
        92: "Cow",
        93: "Bird",
        94: "Rabbit",
    }

    // Adding new key-value pairs in the map
    m_a_p[95] = "Parrot"
}
```

## retrieve a value

```go
// Without value using the blank identifier
// It will only give check result
_, check_variable_name:= map_name[key]

fmt.Println(check_variable_name) // false
```

## delete pair

```go
delete(map_name, key)
```

## map 内部实现

由`hmap`和`bmap`组成. `bmap`就是一个桶

```go
type hmap struct {
    count     int    // map 中的元素数量
    flags     uint8  // 状态标志
    B         uint8  // 2^B 是桶的数量
    noverflow uint16 // 溢出桶的数量
    hash0     uint32 // 哈希种子
    buckets   unsafe.Pointer // 指向主 bucket 数组的指针
    oldbuckets unsafe.Pointer // 扩容时指向旧 bucket 数组
    nevacuate  uintptr // 扩容过程中重新分配 bucket 的进度
    extra     *mapextra // 存储额外的数据，如溢出桶的指针
}

type bmap struct {
    // 注意：bmap 的具体定义在源码中是动态生成的，因此这里只是示意
    topHashes [bucketCnt]uint8 // 每个键的高 8 位哈希值
    keys      [bucketCnt]keyType // 键数组
    values    [bucketCnt]valueType // 值数组
    overflow  *bmap // 溢出桶指针
}
```

`hmap`：存储 map 的元数据和指向桶的指针。

`bmap`：存储实际的键值对和哈希冲突时的溢出桶指针。

## map 的扩容

当map中的元素数量达到一定的负载因子（通常是0.75）时，会触发扩容操作。扩容的过程中，map会将现有的元素重新分配到更大的桶数组中，减少每个桶中的元素数量，从而降低冲突的概率。

一般流程:

1. 创建新的桶数组：根据新的容量创建更大的桶数组，容量通常是原来的两倍。
2. 重新哈希：将旧桶中的元素重新哈希到新桶中，这样可以有效分散原有冲突的元素。
3. 渐进式再哈希：扩容和重新哈希的过程是渐进式完成的，不会在一次操作中完成，以避免长时间的停顿。每次对map进行插入、删除、查找等操作时，会逐步将旧桶中的元素移动到新桶中。

## 桶溢出机制

当一个桶中的元素数量超过一定数量时，Go语言的map会创建溢出桶（overflow bucket）来存储多余的元素。虽然溢出桶在冲突严重时无法完全避免最坏情况的发生，但它们通过链式结构将冲突分散开来，防止单个桶中的元素过多。

## 非线程安全

map不是线程安全的, 如果想实现并发, 可以使用`sync.Map`
sync.Map 使用两种数据结构来实现其并发安全性：

**readOnly**：
一个只读的、不可变的结构，存储最近的键值对，支持无锁读取。
**dirty**：
一个可变的结构，存储所有的键值对，并用互斥锁保护写入和更新操作。
在读取操作时，sync.Map 首先尝试从 readOnly 结构中读取。如果找不到，再从 dirty 结构中读取，并将其提升到 readOnly 结构中。

在写入和更新操作时，sync.Map 会锁住 dirty 结构进行操作，并在适当的时候将 dirty 结构中的数据合并到 readOnly 结构中。

这种设计使得 sync.Map 在读取多于写入的场景下性能非常优越。
