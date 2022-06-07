const publicLoginRegister = {};
(() => {
  const containers = {
    body: document.querySelector("body"),
    loginRegister: document.querySelector(".modal-login-register"),
  };
  const buttons = {
    goToPaiment: document.querySelector(".raffle-tickets-form-button"),
    close: document.querySelector(".modal-login-register .modal-close-button"),
    loginToggle: document.querySelector(".login-toggle-button"),
    registerToggle: document.querySelector(".register-toggle-button"),
  };

  function openModalHendler(event) {
    if (buttons.goToPaiment.dataset.logged === "false") {
      event.preventDefault();
      containers.body.insertAdjacentHTML(
        "afterbegin",
        '<div onclick="publicLoginRegister.closeModalHandler()" class="regulation-backdrop"></div>'
      );
      containers.body.classList.add("backdrop");
      containers.loginRegister.classList.add("open");
    }
  }

  function selectRegisterHandler(){
    containers.loginRegister.classList.remove('login');
    containers.loginRegister.classList.add('register');
  }

  function selectLoginHandler(){
    containers.loginRegister.classList.remove('register');
    containers.loginRegister.classList.add('login');
  }

  

  publicLoginRegister.closeModalHandler = function closeModalHandler() {
    getElement(".regulation-backdrop").remove();
    containers.body.classList.remove("backdrop");
    containers.loginRegister.classList.remove("open");
  };


  buttons.loginToggle.addEventListener("click", selectLoginHandler);
  buttons.registerToggle.addEventListener("click", selectRegisterHandler);
  buttons.goToPaiment.addEventListener("click", openModalHendler);
  buttons.close.addEventListener(
    "click",
    publicLoginRegister.closeModalHandler
  );
})();
