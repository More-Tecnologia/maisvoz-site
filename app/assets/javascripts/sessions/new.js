$(document).ready(function(){
  add_locale_class()
  add_mask_listeners()

  $('#user_country').change(function(){
    $('#user_login, #user_username').val('')

    add_locale_class()
    add_mask_listeners()
  });

  function add_locale_class(){
    if($('#user_country').length > 0){
      let country = $('#user_country option:selected').text()
      let number = XRegExp.matchRecursive(country, '\\(', '\\)', 'g');
      var html_class = 'phone-' + number
      $('#user_login, #user_username').attr('data-mask', html_class)
    }
  }

  function add_mask_listeners(){
    $("input[data-mask='phone-55']").each(function() {
      $(this).mask('+00 00 00000 0000', {clearIfNotMatch: true})
    });

    $("input[data-mask='phone-1']").each(function() {
      $(this).mask('+0 000 000 00000', {clearIfNotMatch: true})
    });

    $("input[data-mask='phone-34']").each(function() {
      $(this).mask('+00 000 000 000', {clearIfNotMatch: true})
    });
  }
})
