const addListenerActivite = () => {
  if (document.querySelector('#concert') == null) return
  document.querySelector("#concert").addEventListener('click', treat);
}

const treat = () => {
document.querySelector("#concert").classList.toggle('select');
  if (document.querySelector("#concert").classList.contains('select')) {
    const url = `/partenaire_interests/:id`;
  }
  else
  { const url = `/partenaire_interests`;
  }

fetch(url)
      .then(response => { console.log(response.text()) });
}


export {addListenerActivite};
