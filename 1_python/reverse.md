# reverse

## reverse()

The reverse() method doesn't return any value. It updates the existing list.

```python
#The original array
arr = [11, 22, 33, 44, 55]
print("Array is :",arr)

res = arr[::-1] #reversing using list slicing
print("Resultant new reversed array:",res)
```

## [::-1]

```python
#The original array
arr = [11, 22, 33, 44, 55]
print("Array is :",arr)

res = arr[::-1] #reversing using list slicing
print("Resultant new reversed array:",res)
```

## reverse part of array

```python
def reverse_sublist(lst,start,end):
    lst[start:end] = lst[start:end][::-1]
    return lst

```
