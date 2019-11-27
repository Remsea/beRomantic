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
};


const cacheaddavatar = () => {
  if (document.querySelector('#clickavatar') == null) {
    return;
  }
  document.querySelector('#clickavatar').addEventListener("click", open);
};
const open = () => {
  event.preventDefault();
  if (document.querySelector('#addavatar').classList.contains("vanish"))
    {cachebis();
    window.setTimeout(vanish, 10);
    }
  else {
    vanish();
    window.setTimeout(cachebis, 700);
  }
};

  const vanish = () => {
  document.querySelector('#addavatar').classList.toggle("vanish");
  };

  const cachebis = () => {
   document.querySelector('#addavatar').classList.toggle("cachebis");
  };

cacheform();
initTypedJS();
cacheaddavatar();
