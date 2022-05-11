const banner = bannerElementFactory();
banner.btnNext = banner.newElement(".store-banner-button__left");
banner.btnPrevious = banner.newElement(".store-banner-button__right");
banner.content = banner.newElement(".store-banner-content");
banner.current = 0;
banner.length = banner.newElements(".store-banner-container").length - 1;
banner.slide = banner.newElement(".store-banner-container");
banner.slides = banner.newElements(".store-banner-container");
banner.width = banner.newElement(".store-banner-container").offsetWidth; 

function bannerElementFactory() {
  const bannerElement = {};
  bannerElement.newElement = (elementName) => {
    return document.querySelector(elementName);
  }

  bannerElement.newElements = (elementName) => {
    return document.querySelectorAll(elementName);
  }

  return bannerElement;
}

function dinamicBanner(delay, banner) {  

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

  const mouseUpHandler = (event) => {
    banner.slides.forEach(slide => {
      slide.style.pointerEvents = 'none';
    })
  }

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
    banner.slides.forEach(slide => {
      slide.style.pointerEvents = 'all';
    })  

  };

  const goPreview = () => {
    if (banner.current > 0) {
      banner.current--;
    } else {
      banner.current = banner.length;
    }
    scroll(banner.current);
    autoSlide();
    banner.slides.forEach(slide => {
      slide.style.pointerEvents = 'all';
    }) 
  };

  banner.content.addEventListener('mousedown', mouseDownHandler);
  banner.content.addEventListener('mousemove', mouseMoveHandler);
  banner.content.addEventListener('touchstart', touchStartHandler, false);
  banner.content.addEventListener('touchend', touchEndHandler, false);
  banner.btnNext.addEventListener('click', goPreview);
  banner.btnPrevious.addEventListener('click', goNext);
  document.addEventListener('mouseup', mouseUpHandler);
  window.addEventListener('resize', resizeHandler);
  autoSlide();
  scroll(0);
}

dinamicBanner(10, banner);
