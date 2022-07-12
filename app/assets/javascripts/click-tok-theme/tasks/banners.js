$(".dashboard-banner-container-premium").owlCarousel({
  loop: true,
  margin: 7,
  autoplay: true,
  autoplayHoverPause: true,
  responsiveClass: true,
  nav: true,
  navText: [
    '<b class="banner-left-buttom-premium"><i class="fa-solid fa-caret-left nav-icon"></i></b>',
    '<b class="banner-right-buttom-premium"><i class="fa-solid fa-caret-right nav-icon"></i></b>',
  ],
  responsive: {
    0: {
      items: 1,
      nav: true,
    },
    600: {
      items: 2,
      nav: true,
    },
    800: {
      items: 3,
      nav: true,
    },
    1000: {
      items: 4,
      nav: true,
      loop: true,
    },
    1400: {
      items: 4,
      nav: true,
      loop: true,
    },
  },
});

$(".dashboard-banner-container-basic").owlCarousel({
  loop: true,
  margin: 4,
  autoplay: true,
  autoplayHoverPause: true,
  responsiveClass: true,
  nav: false,
  navText: [
    '<b class="banner-left-buttom"><i class="fa-solid fa-caret-left nav-icon"></i></b>',
    '<b class="banner-right-buttom"><i class="fa-solid fa-caret-right nav-icon"></i></b>',
  ],
  responsive: {
    0: {
      items: 3,
      nav: false,
    },
    600: {
      items: 6,
      nav: false,
    },
    800: {
      items: 8,
      nav: false,
    },
    1000: {
      items: 10,
      nav: false,
    },
  },
});
