$(document).ready(function(){
  $("label[for='shipping-address-backoffice']").on('click', function() {
    $('div#shipping-address-custom-form').slideUp()
    $('div#shipping-address-backoffice-form').slideDown()
  })

  $("label[for='shipping-address-custom']").on('click', function() {
    $('div#shipping-address-backoffice-form').slideUp()
    $('div#shipping-address-custom-form').slideDown()
  })

  if($("input[type='radio']#shipping-address-custom").prop('checked')) {
    $('div#shipping-address-backoffice-form').hide()
    $('div#shipping-address-custom-form').show()
  }
})
