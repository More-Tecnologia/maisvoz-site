$(document).ready(function() {
  $('#user_country').on('change', function() {
    let country = $('#user_country option:selected').text()
    let number = XRegExp.matchRecursive(country, '\\(', '\\)', 'g');
    $('#user_login,#user_username').val(`+${number}`);
  })
  $(":submit").on('click', function() {
    const regex = /[+]/g;
    let phone = $('#user_login,#user_username').val()
    let number = phone.replace(regex, '');
    $('#user_login,#user_username').val(`${number}`);
  })
})
