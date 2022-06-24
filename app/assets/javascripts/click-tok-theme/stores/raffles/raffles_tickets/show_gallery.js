//RaffleGalleryDesktop
(function raffleGalleryDesktop() {
  const thumbList = document.querySelectorAll(".raffle-tickets-image-list img");
  const stageContainer = document.querySelector(".raffle-tickets-image-container.desktop");

  stageContainer.innerHTML = `<li><img src="${thumbList[0].src}" class="raffle-tickets-image"></li>`;

  const elements = {
    stage: document.querySelector(".raffle-tickets-image"),
    thumbs: document.querySelectorAll(".raffle-tickets-image-list img"),
  };

  //Event Handlers
  function thumbMouseOverHandler(event) {
    elements.stage.src = event.target.src;

    elements.thumbs.forEach((thumb) => thumb.classList.remove("active"));

    event.target.classList.add("active");
  }

  //Event Listeners

  elements.thumbs.forEach((thumb) => {
    thumb.addEventListener("mouseover", thumbMouseOverHandler);
  });
})();

(function raffleGalleryMobile() {
  //Factory
  const elementFactory = (thumbList, circleListContainer, slideContainer, slideListContainer, slideListItems) => {
    const container = document.querySelector(slideContainer);
    const slideList = document.querySelector(slideListContainer);
    const circleList = document.querySelector(circleListContainer);
    const nodeBuilder = (() => {
      const thumbs = document.querySelectorAll(thumbList);

      thumbs.forEach((thumb) => {
        const imageHTML = `<li><img src="${thumb.src}" /></li>`;
        const circleHTML = `<li></li>`;
        slideList.insertAdjacentHTML("beforeend", imageHTML);
        circleList.insertAdjacentHTML("beforeend", circleHTML);
      });
    })();

    const activateCircle = (index) => {
      const circleListItem = circleList.querySelectorAll("li");
      index = index - 1;
      const circleCount = circleListItem.length - 1;
      let slideNumber = index;
      if (index < 0) slideNumber = 0;
      if (index > circleCount) slideNumber = circleCount;

      circleListItem.forEach((thumb) => thumb.classList.remove("active"));
      circleListItem[slideNumber].classList.add("active");
    };

    activateCircle(0);

    const slideItems = document.querySelectorAll(slideListItems);
    const slideCount = slideItems.length;
    const slideWidth = slideItems[0].offsetWidth;
    const cloneLast = document.querySelectorAll(slideListItems)[slideCount - 1].cloneNode(true);
    const cloneFisrt = document.querySelectorAll(slideListItems)[0].cloneNode(true);
    const threshold = slideWidth / 3;

    slideList.appendChild(cloneFisrt);
    slideList.insertBefore(cloneLast, slideItems[0]);

    return {
      activateCircle,
      container,
      slideList,
      slideItems,
      slideCount,
      slideWidth,
      threshold,
    };
  };
  const stateFactory = () => {
    return {
      index: 1,
      evtX: [0, 0],
      left: [0, 0],
    };
  };

  // Configuration
  const elements = elementFactory(
      ".raffle-tickets-image-list img",
      ".circle-list",
      ".slide-container",
      ".slide",
      ".slide li"
    ),
    state = stateFactory();

  // Workers
  const changeSlide = (swift = true) => {
    state.left[1] = -100 * state.index;
    swift ? elements.slideList.classList.remove("shifting") : elements.slideList.classList.add("shifting");
    elements.slideList.style.left = state.left[1] + "%";
    elements.activateCircle(state.index);
  };

  const dragStart = (e) => {
    e = e || window.event;
    state.left[0] = elements.slideList.offsetLeft;
    state.evtX[0] = e.touches[0].clientX;
  };

  const dragEnd = (e) => {
    const dragAmount = state.left[1] - state.left[0];
    dragAmount > elements.threshold && state.index--;
    dragAmount < -elements.threshold && state.index++;
    changeSlide(false);

    if (state.index >= elements.slideCount + 1) {
      state.index = 1;
      elements.slideList.addEventListener("transitionend", changeSlide);
    }

    if (state.index <= 0) {
      state.index = elements.slideCount;
      elements.slideList.addEventListener("transitionend", changeSlide);
    }
  };

  const dragAction = (e) => {
    e = e || window.event;
    e.preventDefault();
    state.evtX[1] = state.evtX[0] - e.touches[0].clientX;
    state.left[1] = state.left[0] - state.evtX[1];
    elements.slideList.style.left = state.left[1] + "px";
  };

  // Handlers
  const touchStartHandler = (e) => {
    dragStart(e);
  };

  const touchEndHandler = (e) => {
    dragEnd(e);
  };

  const touchMoveHandler = (e) => {
    dragAction(e);
  };

  // Listeners
  elements.container.addEventListener("touchstart", touchStartHandler);
  elements.container.addEventListener("touchend", touchEndHandler);
  elements.container.addEventListener("touchmove", touchMoveHandler);
})();
