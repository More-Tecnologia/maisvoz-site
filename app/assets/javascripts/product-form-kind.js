$(document).ready(function() {

  $('#product_form_kind').change(function() {
    var val = $(this).val();

    $('.upgrade-section').addClass('hide');
    $('.career-section').addClass('hide');

    if (val == 'upgrade') {
      $('.upgrade-section').removeClass('hide');
    } else if (val == 'adhesion') {
      $('.career-section').removeClass('hide');
    }
  });

});
