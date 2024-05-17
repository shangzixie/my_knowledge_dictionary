# echo -e

`echo -e` making echo to enable interpret backslash escapes. here are some examples

```
INPUT: echo "abc\n def \nghi" 
OUTPUT:abc\n def \nghi

INPUT: echo -e "abc\n def \nghi"
OUTPUT:abc
 def
ghi
```