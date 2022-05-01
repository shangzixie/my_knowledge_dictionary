# 解答

## 问题

断言expect如何能判定a为1

```javascript
const comp = <SpecificComp
                a={'1'}
                b={'2'}
                c={'3'}
            />
```

## 答案

```javascript
expect(shallow(comp).props().a).toBe('1');
```
