const publicLoginRegister = {};
(() => {
  const containers = {
    body: document.querySelector("body"),
    loginRegister: document.querySelector(".modal-login-register"),
  };
  const buttons = {
    goToPaiment: document.querySelector(".buy-tickets-button"),
    mainLogin: document.querySelector(".header-login-button.open-modal"),
    close: document.querySelector(".modal-login-register .modal-close-button"),
    loginToggle: document.querySelector(".login-toggle-button"),
    registerToggle: document.querySelector(".register-toggle-button"),
  };

  function openModalHendler(event) {
    if (buttons.goToPaiment.dataset.logged === "false") {
      event.preventDefault();
      openModal()
    }
  }

  function openMainModalHendler(event) {
    event.preventDefault();
    openModal();
  }

  function openModal(){
    containers.body.insertAdjacentHTML(
      "afterbegin",
      '<div onclick="publicLoginRegister.closeModalHandler()" class="regulation-backdrop"></div>'
    );
    containers.body.classList.add("backdrop");
    containers.loginRegister.classList.add("open");
  }

  publicLoginRegister.buyAdcashHandler = function buyAdcashHandler(product){
    const productList = document.querySelectorAll(".store--products-item");
    productList.forEach(product => product.classList.remove('selected'));
    const clickedCard = document.querySelector(`.store--products-item.${product}`);
    clickedCard.classList.add('selected-card');
    openModal();
  }

  function selectRegisterHandler() {
    containers.loginRegister.classList.remove("login");
    containers.loginRegister.classList.add("register");
  }

  function selectLoginHandler() {
    containers.loginRegister.classList.remove("register");
    containers.loginRegister.classList.add("login");
  }

  publicLoginRegister.closeModalHandler = function closeModalHandler() {
    document.querySelector(".regulation-backdrop").remove();
    containers.body.classList.remove("backdrop");
    containers.loginRegister.classList.remove("open"); 
    cleanCardClasses()   
  };

  function cleanCardClasses () {
    const selectedCard = document.querySelector('.selected-card');
    if(selectedCard) selectedCard.classList.remove('selected-card');
  }

  buttons.loginToggle.addEventListener("click", selectLoginHandler);
  buttons.registerToggle.addEventListener("click", selectRegisterHandler);
  buttons.mainLogin?.addEventListener("click", openMainModalHendler);
  buttons.close.addEventListener("click", publicLoginRegister.closeModalHandler);
  buttons.goToPaiment && buttons.goToPaiment.addEventListener("click", openModalHendler);
})();
