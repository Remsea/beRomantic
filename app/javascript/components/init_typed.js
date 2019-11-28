import Typed from 'typed.js';


const initTypedJS = () => {
  const span = document.querySelector('#banner-typed-text');

  if (span) {
    new Typed('#banner-typed-text', {
      strings: ['Une relation amoureuse se contruit jour après jour... BeRomantic !'],
      typeSpeed: 100,
      loop: true
    });
  }
}

export { initTypedJS };
