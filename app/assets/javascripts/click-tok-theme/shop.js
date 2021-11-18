$(document).ready(function() {
  $('.confimation-button').on('click', function() {
    if($(this).hasClass('hidden'))
      return;
    // do work
    $(this).addClass('hidden');
    $(this).parent().append( "<a href='#'><div class='buy'><button><i class='fa fa-spinner fa-spin'></i></button></div></a>" );
  })
})
