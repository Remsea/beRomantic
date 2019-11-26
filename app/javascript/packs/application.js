import "bootstrap";
import { initTypedJS } from '../components/init_typed';

function updateTextInput(val) {
          document.getElementById('textInput').value=val;
        };

const cacheform = () => {
  if (document.querySelector('#plusmemo') == null)
    return;

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


document.querySelector('#range').addEventListener('change', (e) => {
  console.log('chagne')
  document.querySelector("#theSquare").setAttribute('y', 100 - document.querySelector('#range').value)
});

initTypedJS();

