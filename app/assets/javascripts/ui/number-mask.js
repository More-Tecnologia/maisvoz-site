$(function() {
  $('[data-number]').each(function () {
    new AutoNumeric(this, AutoNumeric.getPredefinedOptions().commaDecimalCharDotSeparator)
  })
});
