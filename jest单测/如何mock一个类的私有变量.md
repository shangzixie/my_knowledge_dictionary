# 解答

## 问题

想要mock `setNull`

```javascript
  class ClassA {
    private data;
    constructor() {
      this.data = {
        isNull: true,
        setNull: () => someThing,
      }
    }
  }
```

## 答案

```javascript
classA = new classA();

// mock data
classA['data'] = {data: 'test', setNull: jest.fn()}
```
