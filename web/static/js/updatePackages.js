import "babel-polyfill";
const ansiHTML = require('ansi-html');

ansiHTML.setColors({
  reset: ['transparent', 'transparent']
});

const elements = document.getElementsByTagName('pre');
for(let el of elements) {
  el.innerHTML = ansiHTML(el.textContent);
}
