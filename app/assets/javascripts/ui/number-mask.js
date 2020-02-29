$(function() {
  $('[data-number]').each(function () {
    new AutoNumeric(this, AutoNumeric.getPredefinedOptions().commaDecimalCharDotSeparator)
  })
});

$(document).ready(function(){
  $('input.money-br').mask("#.###,##", {reverse: true});
});
