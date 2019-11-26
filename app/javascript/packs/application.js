import "bootstrap";
import { listenerrange } from './rangeoutput.js'; // ./ sinon. va chercher dans node module
function updateTextInput(val) {
          document.getElementById('textInput').value=val;
        };

const cacheform = () => {
  document.querySelector('#plusmemo').addEventListener("click", order);
};
const order = () => {
  if (document.querySelector('.memoform').classList.contains('fadeout'))
    {cache();
    window.setTimeout(fadeout, 10);

    }
  else {
    fadeout();
    window.setTimeout(cache, 700);
  }

};

const fadeout = () => {
  document.querySelector('.memoform').classList.toggle("fadeout");


};

const cache = () => {
   document.querySelector('.memoform').classList.toggle("cache");
}

cacheform();
listenerrange();

