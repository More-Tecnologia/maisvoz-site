function bannerConstruct() {
  function newElement(elementName) {
    return document.querySelector(elementName);
  }

  function newElements(elementName) {
    return document.querySelectorAll(elementName);
  }

  return {
    btnNext: newElement(".store-banner-button__left"),
    btnPrevious: newElement(".store-banner-button__right"),
    content: newElement(".store-banner-content"),
    current: 0,
    length: newElements(".store-banner-container").length - 1,
    slide: newElements(".store-banner-container"),
    width: newElement(".store-banner-container").offsetWidth,
  };
}

function dinamicBanner(delay) {
  const banner = bannerConstruct();

  const autoSlide = (timer = delay) => {
    clearTimeout(banner.timer);
    banner.timer = setTimeout(goNext, timer * 1000);
  };

  const scroll = (scrollValue) => {
    banner.content.scroll(scrollValue * banner.width, 0);
  };

  const mouseDownHandler = (event) => {
    banner.startPosition = event.clientX;
    banner.isClicked = true;
  };

  const mouseMoveHandler = (event) => {
    if (banner.isClicked && event.clientX < banner.startPosition) {
      goNext();
      banner.isClicked = false;
    } else if (banner.isClicked && event.clientX > banner.startPosition) {
      goPreview();
      banner.isClicked = false;
    }
  };

  const touchStartHandler = (event) => {
    banner.startPosition = event.targetTouches[0].pageX;
  };

  const touchEndHandler = (event) => {
    if (event.changedTouches[0].pageX < banner.startPosition) {
      goNext();
    } else if (event.changedTouches[0].pageX > banner.startPosition) {
      goPreview();
    }
  };

  const resizeHandler = () => {
    banner.width = banner.slide.offsetWidth;
    scroll(banner.current);
  };

  const goNext = () => {
    if (banner.current < banner.length) {
      banner.current++;
    } else {
      banner.current = 0;
    }
    scroll(banner.current);
    autoSlide();
  };

  const goPreview = () => {
    if (banner.current > 0) {
      banner.current--;
    } else {
      banner.current = banner.length;
    }
    scroll(banner.current);
    autoSlide();
  };

  banner.content.addEventListener("mousedown", mouseDownHandler);
  banner.content.addEventListener("mousemove", mouseMoveHandler);
  banner.content.addEventListener("touchstart", touchStartHandler, false);
  banner.content.addEventListener("touchend", touchEndHandler, false);
  banner.btnNext.addEventListener("click", goPreview);
  banner.btnPrevious.addEventListener("click", goNext);
  window.addEventListener("resize", resizeHandler);
  autoSlide();
  scroll(0);
}

dinamicBanner(10);
