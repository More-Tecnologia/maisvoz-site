$(document).ready(function() {

  $('#product_form_kind').change(function() {
    var val = $(this).val();
    if (val == 'upgrade') {
      $('.upgrade-section').removeClass('hide');
    } else {
      $('.upgrade-section').addClass('hide');
    }
  });

});
