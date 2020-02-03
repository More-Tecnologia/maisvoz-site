grecaptcha.ready(function() {
  grecaptcha.execute("<%= ENV['GOOGLE_RECAPTCHA_KEY'] %>", { action: 'homepage' }).then(function(token) {
    $('input#g_recaptcha_response').val(token)
  });
});
