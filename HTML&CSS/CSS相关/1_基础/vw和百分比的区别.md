# [链接](https://stackoverflow.com/questions/36876770/css-what-is-best-to-use-for-this-case-px-vw-wh-or-em)

Note that I only mentioned the ones you asked about.

Here you can see the full list of CSS measurement units: [CSS Units in W3Schools](https://www.w3schools.com/cssref/css_units.asp)

Rather than telling you which one is the "right one", I would rather want you to understand what each one actually is.

Pixels (`px`): Absolute pixels. So for example, `20px` will be literally 20 pixels on any screen. If a monitor is of 1980x1200, and you set an element's height to `200px`, the element will take 200 pixels out of that.

Percentage (`%`): Relative to the parent value.

So for this example:

```html
<div style="width: 200px;">
    <div style="width: 50%;"></div>
</div>
```

The inner div will have a width of 100 pixels.

Viewport height/width (`vw/vh`): Size relative to the viewport (browser window, basically).

Example:

```css
.myDiv {
    width: 100vw;
    height: 100vh;
    background-color: red;
}
```

Will make an cover the whole browser in red. This is very common among [flexboxes](https://css-tricks.com/snippets/css/a-guide-to-flexbox/) as it's naturally responsive.

Emeters (em) and Root Emeters (rem): em is relative to the parent element's font size. rem will be relative to the html font-size (mostly 16 pixels). This is very useful if you want to keep an "in mind relativity of sizes" over your project, and not using variables by pre-processors like Sass and Less. Just easier and more intuitive, I guess.

Example:

```css
.myDiv {
  font-size: 0.5rem;
}
```

Font size will be 8 pixels.

Now that you know, choose the right one for the right purpose.