import "bootstrap";

import { listenerrange } from './rangeoutput.js'; // ./ sinon. va chercher dans node module
import { initTypedJS } from '../components/init_typed';
import { showcalendar } from './showcalendar.js';

function updateTextInput(val) {
          document.getElementById('textInput').value=val;
        };

const cacheform = () => {
  if (document.querySelector('#plusmemo') == null)
    return;

  document.querySelector('#plusmemo').addEventListener("click", order);
};
const order = () => {
  if (document.querySelector('.memoform').classList.contains('show'))
    {hide();
    }
  else {
    show();
    // window.setTimeout(show, 700);
  }

};

const show = () => {
  document.querySelector('.memoform').classList.remove("hide");
  document.querySelector('.memoform').classList.remove("cache");
  document.querySelector('.memoform').classList.add("show");

}
const hide = () => {
document.querySelector('.memoform').classList.remove("show");
  document.querySelector('.memoform').classList.add("hide");
   document.querySelector('.memoform').classList.add("cache");
}
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
listenerrange();

initTypedJS();
showcalendar();
cacheaddavatar();


