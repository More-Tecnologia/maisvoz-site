$(document).ready(function() {
  $('#user_country').on('change', function() {
    let country = $('#user_country option:selected').text()
    let number = XRegExp.matchRecursive(country, '\\(', '\\)', 'g');
    $('#user_login,#user_username').val(`+${number}`);
  })
})
