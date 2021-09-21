$(document).ready(function(){
  add_locale_class()
  add_mask_listeners()

  $('#user_country').change(function(){
    $('#user_login, #user_username').val('')

    add_locale_class()
    add_mask_listeners()
  });

  function add_locale_class(){
    var html_class = 'phone-' + $('#user_country').val().toLowerCase()

    $('#user_login, #user_username').attr('data-mask', html_class)
  }

  function add_mask_listeners(){
    $("input[data-mask='phone-br']").each(function() {
      $(this).mask('00 00000 0000', {clearIfNotMatch: true})
    });

    $("input[data-mask='phone-us']").each(function() {
      $(this).mask('000 000 00000', {clearIfNotMatch: true})
    });

    $("input[data-mask='phone-es']").each(function() {
      $(this).mask('000 00 00 00', {clearIfNotMatch: true})
    });
  }
})
