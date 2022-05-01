# 问题

I'm trying to get the elements by class name from the DOM in typescript. It seems pretty straight forward what I'm doing here but the console shows an error.

```javascript
function showSlides() {
   var i;
   var slides = <HTMLElement[]<any>document.getElementsByClassName('slide');

   for (i = 0; i < slides.length; i++) {
     slides[i].style.display = "none";
   }
}
```

The expected result should be an array with 3 items and it should change the display style to none, but the actual result is a JS error: `Uncaught TypeError: Cannot read property 'style' of undefined`.

## 解决

```javascript
const showSlides = () => {
    const slides = document.getElementsByClassName('slide');

    for (let i = 0; i < slides.length; i++) {
        const slide = slides[i] as HTMLElement;
        slide.style.display = "none";
    }
};
```

## reference

[1](https://stackoverflow.com/questions/54630972/how-to-getelementsbyclassname-in-typescript)
[2](https://github.com/Microsoft/TypeScript/issues/3263)
