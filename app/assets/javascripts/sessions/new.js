$(document).ready(function(){
  $('#user_country').change(function(){
    var html_class = 'phone-' + this.value.toLowerCase()

    $('#user_login, #user_username').val('')
    $('#user_login, #user_username').attr('data-mask', html_class)

    $("input[data-mask='phone-br']").each(function() {
      $(this).mask('00 00000 0000', {clearIfNotMatch: true})
    });

    $("input[data-mask='phone-us']").each(function() {
      $(this).mask('000 000 00000', {clearIfNotMatch: true})
    });

    $("input[data-mask='phone-es']").each(function() {
      $(this).mask('000 00 00 00', {clearIfNotMatch: true})
    });
  });
})
