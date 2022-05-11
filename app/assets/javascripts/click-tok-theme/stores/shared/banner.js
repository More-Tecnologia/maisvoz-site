function bannerElementFactory() {
  const bannerElement = {};

  bannerElement.newElement = (elementName) => {
    return document.querySelector(elementName);
  };

  bannerElement.newElements = (elementName) => {
    return document.querySelectorAll(elementName);
  };

  return bannerElement;
}

function dynamicBanner(delay) {
  const banner = bannerElementFactory();
  banner.btnNext = banner.newElement(".store-banner-button__left");
  banner.btnPrevious = banner.newElement(".store-banner-button__right");
  banner.content = banner.newElement(".store-banner-content");
  banner.current = 0;
  banner.length = banner.newElements(".store-banner-container").length - 1;
  banner.slide = banner.newElement(".store-banner-container");
  banner.slides = banner.newElements(".store-banner-container");
  banner.width = banner.newElement(".store-banner-container").offsetWidth;

  autoSlide();
  banner.content.addEventListener("mousedown", mouseDownHandler);
  banner.content.addEventListener("mousemove", mouseMoveHandler);
  banner.content.addEventListener("touchstart", touchStartHandler, false);
  banner.content.addEventListener("touchend", touchEndHandler, false);
  banner.btnNext.addEventListener("click", goPreview);
  banner.btnPrevious.addEventListener("click", goNext);
  document.addEventListener("mouseup", mouseUpHandler);
  removeButton();
  scroll(0);
  window.addEventListener("resize", resizeHandler);

  function autoSlide(timer = delay) {
    clearTimeout(banner.timer);
    banner.timer = setTimeout(goNext, timer * 1000);
  }

  function mouseDownHandler(event) {
    banner.startPosition = event.clientX;
    banner.isClicked = true;
  }

  function mouseUpHandler(event) {
    banner.slides.forEach((slide) => {
      slide.style.pointerEvents = "none";
    });
  }

  function mouseMoveHandler(event) {
    if (banner.isClicked && event.clientX < banner.startPosition) {
      goNext();
      banner.isClicked = false;
    } else if (banner.isClicked && event.clientX > banner.startPosition) {
      goPreview();
      banner.isClicked = false;
    }
  }

  function removeButton() {
    if (banner.length === 0) {
      banner.btnNext.style.display = "none";
      banner.btnPrevious.style.display = "none";
    }
  }

  function resizeHandler() {
    banner.width = banner.slides[banner.current].offsetWidth;
    scroll(banner.current);
  }

  function scroll(scrollValue) {
    banner.content.scroll(scrollValue * banner.width, 0);
  }

  function touchStartHandler(event) {
    banner.startPosition = event.targetTouches[0].pageX;
  }

  function touchEndHandler(event) {
    if (event.changedTouches[0].pageX < banner.startPosition) {
      goNext();
    } else if (event.changedTouches[0].pageX > banner.startPosition) {
      goPreview();
    }
  }

  function goEnd() {
    banner.current = banner.length;
    banner.slides[0].style.order = "3";
    banner.content.style.scrollBehavior = "auto";
    scroll(banner.current);
    banner.current = banner.length - 1;
    banner.content.style.scrollBehavior = "smooth";
    banner.isLooping = true;
  }

  function goStart() {
    banner.current = 0;
    banner.slides[banner.length].style.order = "1";
    banner.content.style.scrollBehavior = "auto";
    scroll(banner.current);
    banner.current = 1;
    banner.content.style.scrollBehavior = "smooth";
    banner.isLooping = true;
  }

  function resetStart() {
    banner.current = 0;
    banner.slides[banner.length].style.order = "2";
    banner.content.style.scrollBehavior = "auto";
    scroll(banner.current);
    banner.isLooping = false;
    banner.content.style.scrollBehavior = "smooth";
  }

  function resetEnd() {
    banner.current = banner.length;
    banner.slides[0].style.order = "2";
    banner.content.style.scrollBehavior = "auto";
    scroll(banner.current);
    banner.isLooping = false;
    banner.content.style.scrollBehavior = "smooth";
  }

  function goNext() {
    if (banner.current === 1 && banner.isLooping === true) {
      resetStart();
    }

    if (banner.current < banner.length) {
      banner.current++;
    } else {
      goStart();
    }

    scroll(banner.current);
    autoSlide();
    banner.slides.forEach((slide) => {
      slide.style.pointerEvents = "all";
    });
  }

  function goPreview() {
    if (banner.current === banner.length - 1 && banner.isLooping === true) {
      resetEnd();
    }

    if (banner.current > 0) {
      banner.current--;
    } else {
      goEnd();
    }

    scroll(banner.current);
    autoSlide();
    banner.slides.forEach((slide) => {
      slide.style.pointerEvents = "all";
    });
  }
}

dynamicBanner(10);
