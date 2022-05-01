# sort

## sort in common

```python
cars = ['Ford', 'BMW', 'Volvo']

cars.sort()
print(cars) # ['BMW', 'Ford', 'Volvo']
```

## sort part of array

```python
nums[a:b] = sorted(nums[a:b])
```

## sort a list of tuples by a given index in Python

### sort() + lambda

```python
test_list = [['Rash', 4, 28], ['Varsha', 2, 20], ['Nikhil', 1, 20], ['Akshat', 3, 21]]

# printing original list
print ("The original list is : " + str(test_list))

# using sort() + lambda
# to sort list of list
# sort by second index
test_list.sort(key = lambda x: x[1])
```

### sorted() + itemgetter()

```python
from operator import itemgetter
# initializing list
test_list = [['Rash', 4, 28], ['Varsha', 2, 20], ['Nikhil', 1, 20], ['Akshat', 3, 21]]

# printing original list
print ("The original list is : " + str(test_list))

# using sort() + lambda
# to sort list of list
# sort by second index
res = sorted(test_list, key = itemgetter(1))

# printing result
print ("List after sorting by 2nd element of lists : " + str(res))
```