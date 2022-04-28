  $('.dashboard-banner-container-premium').owlCarousel({
    loop:true,
    margin:0,
    responsiveClass:true,
    nav: true,
    navText : ['<b class="banner-left-buttom-premium"><</b>',
      '<b class="banner-right-buttom-premium">></b>'],
    responsive:{
      0:{
          items:3,
          nav:true
      },
      400:{
          items:3,
          nav:true
      },
        800:{
          items:4,
          nav:true
      },
      1000:{
          items:5,
          nav:true,
          loop:true
      }
    }
  })
  
  $('.dashboard-banner-container-basic').owlCarousel({
    loop:true,
    margin:0,
    responsiveClass:true,
    nav: true,
    navText : ['<b class="banner-left-buttom"><</b>',
      '<b class="banner-right-buttom">></b>'],
    responsive:{
      0:{
          items:4,
          nav:true
      },
      600:{
          items:6,
          nav:true
      },
        800:{
          items:8,
          nav:true
      },
      1000:{
          items:10,
          nav:true,
          loop:true
      }
    }
  })