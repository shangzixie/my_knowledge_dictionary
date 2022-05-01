# 如果很多个if嵌套一个continue

```java

for (int i = 0; i < 10; i++) {
    System.out.println(i);
    if (i == 2) {
        if (i == 2) {
            if (i == 2) {
                System.out.println("1 i==2");
                continue;
            }
            System.out.println("2 i==2");//条件满足时在continue后面不执行
        }
        System.out.println("3 i==2");//条件满足时在continue后面不执行
    }
    System.out.println("name");//条件满足时在continue后面不执行

```

结果为
```
0

name

1

name

2

1 i==2

3

name

4

name

5

name

6

name

7

name

8

name

9

name

显然，continue会终止当次循环，之后的代码不再执行，开始执行下一次循环

```
