# 判断一个object内有多少个key

## method 1

Count the Number of Key in an Object Using `for...in`

```JavaScript
// program to count the number of keys/properties in an object

const student = {
    name: 'John',
    age: 20,
    hobbies: ['reading', 'games', 'coding'],
};

let count = 0;

// loop through each key/value
for(let key in student) {

    // increase the count
    ++count;
}

console.log(count);
```

but: While using the for...in loop, it will also count inherited properties.

```javascript
const student = {
    name: 'John',
    age: 20,
    hobbies: ['reading', 'games', 'coding'],
};

const person = {
    gender: 'male'
}

student.__proto__ = person;

let count = 0;

for(let key in student) {

    // increase the count
    ++count;
}

console.log(count); // 4

```

If you only want to loop through the object's own property, you can use the `hasOwnProperty()` method

```javascript
if (student.hasOwnProperty(key)) {
    ++count:
}
```

## method 2

Count the Number of Key in an Object Using Object.key()

```javascript
// program to count the number of keys/properties in an object

const student = {
    name: 'John',
    age: 20,
    hobbies: ['reading', 'games', 'coding'],
};

// count the key/value
const result = Object.keys(student).length;

console.log(result);

```

