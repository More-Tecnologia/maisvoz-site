function changeSlide() {
  let nextSlider = parseInt(document.querySelector("input[name = radio-btn]:checked").id[5]) + 1;
  if (nextSlider > 4) nextSlider = 1;
  document.getElementById("radio" + nextSlider).checked = true;
}

function autoChangeSlide(seconds = 8) {
  setInterval(changeSlide, seconds * 1000);
}

autoChangeSlide();
