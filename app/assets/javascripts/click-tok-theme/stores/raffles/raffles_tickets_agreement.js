const publicRegulation = {};
(() => {
  const containers = {
    body: document.querySelector("body"),
    regulation: document.querySelector(".modal-regulation"),
  };
  const buttons = {
    regulation: document.querySelector(".regulation-button"),
    close: document.querySelector(".modal-close-button"),
  };

  function openModalHendler() {
    containers.body.insertAdjacentHTML(
      "afterbegin",
      '<div onclick="publicRegulation.closeModalHandler()" class="regulation-backdrop"></div>'
    );
    containers.body.classList.add("backdrop");
    containers.regulation.classList.add("open");
  }

  publicRegulation.closeModalHandler = function closeModalHandler() {
    getElement(".regulation-backdrop").remove();
    containers.body.classList.remove("backdrop");
    containers.regulation.classList.remove("open");
  };

  buttons.regulation.addEventListener("click", openModalHendler);
  buttons.close.addEventListener('click', publicRegulation.closeModalHandler);
})();
