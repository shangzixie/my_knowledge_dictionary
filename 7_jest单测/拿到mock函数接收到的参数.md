
# 解答

## 答案

第一个参数

```javascript
mockFn = jest.fn();
expect(mockFn.mock.calls[0][0]).toBe(`paragraph-extend-render-${boxId}`);
```
