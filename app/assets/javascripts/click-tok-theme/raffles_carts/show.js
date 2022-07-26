(function rafflesCartsShow(){
  const bubble = document.querySelector('.speech-bubble'),
    disabledButton = document.querySelector('.btn.disabled');

    bubble.onclick = event => {
      event.stopPropagation();
      event.target.classList.remove('active');
    }

    disabledButton.onclick = event => bubble.classList.add('active');
})()
