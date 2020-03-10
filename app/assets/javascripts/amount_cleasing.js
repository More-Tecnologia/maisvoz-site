$('#credit_debit_form_amount').focusout(function() {
  $(this).val($(this).val().replace('.','').replace(',','.'))
  $(this).text($(this).val());
});
