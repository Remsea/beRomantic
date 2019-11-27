const showcalendar = () => {
if (document.querySelector('#showmore') == null)
    return;
document.querySelector('#showmore').addEventListener('click', update);
}

const update = (event) => {
  let testfin = document.querySelector('#showmore').innerText == 'Tout est affiché';
  if (testfin)
    {return;}
  else {
    const nb = event.currentTarget.dataset.number
    const url = `/pages?nb=${nb}`
    const monUl = document.querySelector('#showmore')
    monUl.insertAdjacentHTML('afterbegin', "<div class=\"spinner-border\"><span class=\"sr-only mr-2\">Loading...</span></div>");

    fetch(url)
      .then(response => { return response.text() })
      .then(data => { replacecal(data)})
      .then(() => {divmodif()})
    };
    if (!testfin) {document.querySelector('.spinner-border').remove()};
}

const replacecal = (data) => {
 if (document.querySelector('#containercalendar') == null)
    {return;}
  document.querySelector('#containercalendar').innerHTML = data;
  }

const divmodif = () => {
  document.querySelector('#showmore').dataset.number += 5;
  let num = parseInt(document.querySelector('#num').innerText, 10);
  if (num - 5 > 0) {
  document.querySelector('#num').innerText = num - 5 ;
  }
  else {
    let mydiv = document.querySelector('#showmore');
    mydiv.innerHTML = 'Tout est affiché';
    mydiv.style["boxShadow"] = 'none';
    }
  }

export { showcalendar };
