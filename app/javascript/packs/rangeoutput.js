const listenerrange = () => {
  if (document.querySelector('#rangebar') == null) return
  document.querySelector("#rangebar").addEventListener('change', affiche);
}

const affiche = (event) => {
  document.querySelector("#rangevaleur").innerText= event.currentTarget.value;
}

export { listenerrange };
