let boxesStore = document.querySelectorAll('.box-store');
console.log(boxesStore)


function selectedBanner(){
  boxesStore.forEach((item) => {
    if(item.href == window.location.href){
      item.classList.add('selected-background');
    }
    else {
      item.classList.remove('selected-background');
    }
  });

}

selectedBanner();
