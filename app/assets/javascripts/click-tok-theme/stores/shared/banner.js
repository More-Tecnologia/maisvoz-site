function dinamicBanner() {
  const banner = {};
  const bannerWrapper = document.querySelector(".store-banner-content");
  const bannerSize = document.querySelector(".store-banner-container").offsetWidth;
  const bannerCount = document.querySelectorAll(".store-banner-container").length;
  const buttonPrevious = document.querySelector(".store-banner-button__left");
  const buttonNext = document.querySelector(".store-banner-button__right");  
  let currentBanner = 0;

  banner.goNext = () => {
    if (currentBanner < bannerCount-2) {
      currentBanner++
    }else {
      currentBanner = bannerCount-1
    }
    bannerWrapper.scroll(currentBanner * bannerSize, 0);
  };

  banner.goPrevious = () => {
    if(currentBanner > 0){ 
      currentBanner--
    }else{
      currentBanner = 0 
    }
    bannerWrapper.scroll(currentBanner * bannerSize, 0);
  };

  buttonPrevious.addEventListener('click', banner.goPrevious);
  buttonNext.addEventListener('click', banner.goNext);

  return banner;
}

const storeBanner = dinamicBanner();

