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
    console.log(interval);
    clearInterval(interval);
    console.log(interval);
    if (currentBanner < bannerCount-1) {
      currentBanner++
    }else {
      currentBanner = 0
    }
    bannerWrapper.scroll(currentBanner * bannerSize, 0);
    
  };

  banner.goPrevious = () => {
    clearInterval(interval);
    if(currentBanner > 0){ 
      currentBanner--
    }else{
      currentBanner = bannerCount-1
    }
    bannerWrapper.scroll(currentBanner * bannerSize, 0);
    interval();
  };
  
  banner.goStart();
  buttonPrevious.addEventListener('click', banner.goPrevious);
  buttonNext.addEventListener('click', banner.goNext);
  const interval = setInterval(banner.goNext, 2000);
  return banner;
}

const storeBanner = dinamicBanner();

