function dinamicBanner() {
  const banner = {};
  const bannerWrapper = document.querySelector(".store-banner-content");
  const bannerSize = document.querySelector(".store-banner-container").offsetWidth;
  const bannerCount = document.querySelectorAll(".store-banner-container").length;
  const buttonPrevious = document.querySelector(".store-banner-button__left");
  const buttonNext = document.querySelector(".store-banner-button__right");  
  let currentBanner = 0;

  banner.goStart = () => {
    bannerWrapper.scroll(0, 0);
  }

  banner.goNext = () => {
    if (currentBanner < bannerCount-2) {
      currentBanner++
      buttonPrevious.classList.add('active');
    }else {
      currentBanner = bannerCount-1
      buttonNext.classList.remove('active');
      buttonPrevious.classList.add('active');
    }
    bannerWrapper.scroll(currentBanner * bannerSize, 0);
  };

  banner.goPrevious = () => {
    if(currentBanner > 1){ 
      currentBanner--
      buttonNext.classList.add('active');
    }else{
      currentBanner = 0 
      buttonPrevious.classList.remove('active');
      buttonNext.classList.add('active');
    }
    bannerWrapper.scroll(currentBanner * bannerSize, 0);
  };

  banner.goStart();
  buttonPrevious.addEventListener('click', banner.goPrevious);
  buttonNext.addEventListener('click', banner.goNext);

  return banner;
}

const storeBanner = dinamicBanner();

