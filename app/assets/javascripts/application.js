// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require 'bootstrap/dist/js/bootstrap'
//= require 'slick-carousel/slick/slick'
//= require 'webui-popover/dist/jquery.webui-popover'
//= require 'autonumeric/dist/autoNumeric.min'
//= require twitter-bootstrap-wizard/jquery.bootstrap.wizard
//= require jquery-mask-plugin/dist/jquery.mask
//= require notifyjs
//= require bootstrap-datepicker
//= require raphael
//= require product-form-kind
//= require withdraw-simulator
//= require zipcode-fill
//= require dashboard-carousel
//= require rails.validations
//= require rails.validations.simple_form
//= require theme/jquery.core
//= require theme/wow.min
//= require theme/jquery.app

$(document).ready(function() {
  $("#sidebar-menu a").each(function() {
    if (this.href == window.location.href) {
      $(this).addClass("active");
      $(this).parent().addClass("active"); // add active to li of the current link
      $(this).parent().parent().prev().addClass("active"); // add active class to an anchor
      $(this).parent().parent().prev().addClass("subdrop"); // add active class to an anchor
      $(this).parent().parent().show();
      $(this).parent().parent().prev().click(); // click the item to make it drop
    }
  });
});
