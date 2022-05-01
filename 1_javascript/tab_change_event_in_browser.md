# tab_change_event_in_browser/浏览器tab改变触发的事件

```JavaScript
document.addEventListener("visibilitychange", function() {
  if (document.visibilityState === 'visible') {
    backgroundMusic.play();
  } else {
    backgroundMusic.pause();
  }
});
```
