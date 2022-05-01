# 浅谈React的`useEffect`和`useLayoutEffect`

## [区别](https://dev.to/nibble/what-is-uselayouteffect-hook-and-when-do-you-use-it-3lan)

useEffect执行时机：

1. User interacts with App. Let us say the user clicks a button.
2. Component state changes
3. The DOM is mutated
4. Changes are painted on the screen
5. `cleanup` function is invoked to clean effects from previous render if `useEffect` dependencies have changed.
6. `useEffect` hook is called after `cleanup`.

`useLayoutEffect`执行时机：

1. User interacts with App. Let us say the user clicks a button.
2. Component state changes
3. The DOM is mutated
4. `cleanup` function is invoked to clean effects from previous render if `useLayoutEffect dependencies` have changed.
5. useLayoutEffect hook is called after cleanup.
6. Changes are painted on the screen

`useEffect`和`useLayoutEffect`最大的区别就是invoke时机，`useEffect` hook is invoked after the DOM is painted. `useLayoutEffect` hook on the other hand is invoked synchronously before changes are painted on the screen

## 如何选择

1. use `useLayoutEffect` hook instead of `useEffect` hook if your effect will mutate the DOM. useEffect hook is called after the screen is painted. Therefore mutating the DOM again immediately after the screen has been painted, will cause a flickering effect if the mutation is visible to the client. `useLayoutEffect` hook on the other hand is called before the screen is painted but after the DOM has been mutated. The undesirable behavior, of mutating the DOM immediately after painting the screen, described with `useEffect` hook above can be avoided.
