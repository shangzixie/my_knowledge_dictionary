let timer; // 维护同一个timer
debounce = (fn, delay) => {
    clearTimeout(timer);
    timer = setTimeout( () => fn(), delay);
}

testDebounce = () => {
    console.log('test');
}

document.onmousemove = () => {
  debounce(testDebounce, 1000);
}
/*
0 1 2 3 4 5 6 7 8 9
0 1 2 3 4
*/