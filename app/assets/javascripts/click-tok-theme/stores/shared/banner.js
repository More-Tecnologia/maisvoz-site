function dinamicBanner() {
  const banner = {};
  const bannerWrapper = document.querySelector(".store-banner-content");
  const bannerSize = document.querySelector(".store-banner-container").offsetWidth;
  const bannerCount = document.querySelectorAll(".store-banner-container").length;
  const buttonPrevious = document.querySelector(".store-banner-button__left");
  const buttonNext = document.querySelector(".store-banner-button__right");  
  let currentBanner = 0;

  banner.goNext = () => {
    currentBanner < bannerCount-2 ? currentBanner++ : currentBanner = bannerCount-1 ;  
    bannerWrapper.scroll(currentBanner * bannerSize, 0);
    console.log(currentBanner);
  };

  banner.goPrevious = () => {
    currentBanner > 0 ? currentBanner-- : currentBanner = bannerCount-1 ;  
    bannerWrapper.scroll(currentBanner * bannerSize, 0);
    console.log(currentBanner);
  };

  buttonPrevious.addEventListener('click', banner.goPrevious);
  buttonNext.addEventListener('click', banner.goNext);

  return banner;
}

const storeBanner = dinamicBanner();

