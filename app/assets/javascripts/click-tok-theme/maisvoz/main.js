!function(e){e(".mainmenu ul#primary-menu").slicknav({allowParentLinks:!0,prependTo:".responsive-menu"}),jQuery(window).on("scroll",(function(){e(this).scrollTop()>10?e(".header").addClass("sticky"):e(".header").removeClass("sticky")})),e(".mainmenu li a, .logo a,.slicknav_nav li a").on("click",(function(){if(location.pathname.replace(/^\//,"")==this.pathname.replace(/^\//,"")&&location.hostname==this.hostname){var o=e(this.hash);if((o=o.length&&o||e("[name="+this.hash.slice(1)+"]")).length){var t=o.offset().top;return e("html,body").animate({scrollTop:t},2e3),!1}}})),e(window).on("scroll",(function(){e(this).scrollTop()>600?e(".scrollToTop").fadeIn():e(".scrollToTop").fadeOut()})),e(".scrollToTop").on("click",(function(){return e("html, body").animate({scrollTop:0},2e3),!1})),e(".screenshot-wrap").slick({autoplay:!0,dots:!0,autoplaySpeed:1e3,slidesToShow:3,centerPadding:"20%",centerMode:!0,prevArrow:"",nextArrow:"",responsive:[{breakpoint:992,settings:{slidesToShow:1,centerPadding:"33.3%"}},{breakpoint:576,settings:{slidesToShow:1,centerPadding:"0"}}]});var o=e(".testimonial-wrap");o.owlCarousel({loop:!0,dots:!0,mouseDrag:!1,autoplay:!1,autoplayTimeout:4e3,nav:!1,items:1}),o.on("translate.owl.carousel",(function(){e(".single-testimonial-box img, .author-rating").removeClass("animated zoomIn").css("opacity","0")})),o.on("translated.owl.carousel",(function(){e(".single-testimonial-box img, .author-rating").addClass("animated zoomIn").css("opacity","1")})),o.on("changed.owl.carousel",(function(o){var t=o.item.index,n=e(o.target).find(".owl-item").eq(t).prev().find(".author-img").html(),a=e(o.target).find(".owl-item").eq(t).next().find(".author-img").html();e(".thumb-prev .author-img").html(n),e(".thumb-next .author-img").html(a)})),e(".thumb-next").on("click",(function(){return o.trigger("next.owl.carousel",[300]),!1})),e(".thumb-prev").on("click",(function(){return o.trigger("prev.owl.carousel",[300]),!1})),e(".hero-area-slider").owlCarousel({loop:!0,dots:!1,autoplay:!0,autoplayTimeout:5e3,nav:!0,navText:["<i class='icofont icofont-long-arrow-left'></i>","<i class='icofont icofont-long-arrow-right'></i>"],items:1,animateIn:"fadeIn",animateOut:"fadeOut",mouseDrag:!0,touchDrag:!0,responsive:{768:{mouseDrag:!1,touchDrag:!1}}});new Swiper(".hero-slider",{slidesPerView:1,spaceBetween:0,loop:!0,pagination:{el:".swiper-pagination",clickable:!0,renderBullet:function(e,o){return'<span class="'+o+'">0'+(e+1)+"</span>"}},navigation:{nextEl:".swiper-button-next",prevEl:".swiper-button-prev"}});e(".icon-so").on("click",(function(){return e(".icon-so").removeClass("active"),e(this).addClass("active"),e(".swiper-container").css("display","none"),e("#"+e(this).data("slider")).css("display","block"),!1})),e(".swiper-container").css("display","none"),e("#slider-android").css("display","block"),e("#slider-video").css("display","block"),e(".popup-youtube").magnificPopup({type:"iframe"}),e.extend(!0,e.magnificPopup.defaults,{iframe:{patterns:{youtube:{index:"youtube.com/",id:"v=",src:"https://www.youtube.com/embed/%id%?autoplay=1"}}}}),e(".counter").counterUp({delay:20,time:3e3}),e.fn.YTPlayer&&e(".player").YTPlayer(),e("#toggle-switcher").on("click",(function(){e(this).hasClass("open")?(e(this).removeClass("open"),e("#switch-style").animate({right:"-232px"})):(e(this).addClass("open"),e("#switch-style").animate({right:"0"}))})),jQuery(window).on("load",(function(){jQuery("#preloader").fadeOut(500)})),(new WOW).init()}(jQuery);