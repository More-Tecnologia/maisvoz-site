$('.owl-carousel').owlCarousel({
  loop: true,
  margin:10,
  nav: true,
  autoplay: true,
  nav: false,
  dots: false,
  responsive:{
      0:{
          items:1
      },
      600:{
          items:2
      },
      1000:{
          items:3
      }
  }
})
