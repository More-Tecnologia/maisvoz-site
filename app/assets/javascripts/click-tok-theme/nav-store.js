let bannerNav = document.querySelectorAll('.store-banner');


function selectedBanner(){
  bannerNav.forEach((item) => {
    console.log(item.pathname)
    if(item.pathname == window.location.pathname){
      item.classList.add('selected-background');
    }
    else {
      item.classList.remove('selected-background');
    }
  });

}

selectedBanner();
