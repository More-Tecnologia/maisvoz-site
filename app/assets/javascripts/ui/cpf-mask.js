$(function() {
  $('.cpf-mask').each(function() {
    $(this).mask('000.000.000-00', {clearIfNotMatch: true})
  });
});
