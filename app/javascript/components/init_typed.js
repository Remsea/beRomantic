import Typed from 'typed.js';


const initTypedJS = () => {
  const span = document.querySelector('#banner-typed-text');

  if (span) {
    new Typed('#banner-typed-text', {
      strings: ['Fini les prises de tête, avec BeRomantic, votre coach personnalisé !'],
      typeSpeed: 50,
      loop: true
    });
  }
}

export { initTypedJS };
