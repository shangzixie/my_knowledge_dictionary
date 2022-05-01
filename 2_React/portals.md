# portals

## why use portals

Portals provide a first-class way to render children into a DOM node that exists outside the DOM hierarchy of the parent component.

换句话说，一个组件`<A />` 定义如下, 组件内有一个child，为组件`<B />`

```javascript
const A = (props) => {
  return ({
    <B />
  });
}

```

但是组件`B`在`A`中渲染可能会导致一些问题, 所以我们可以把`B`渲染到别处(domNode)

```javascript
const B = (props) => {
  const domNode = document.createElement('div');
  document.appendChild(domNode);

  return ReactDOM.createPortal(
    props.children,
    domNode
  );
}

```

## consume the component

```javascript
<A>
  <B>
    <some other component>
  <B />
<A />

```

此时组件`B`和他的`children`都会被渲染到domNode, 而不是组件`A`下面

## reference

[react docs](https://reactjs.org/docs/portals.html)
