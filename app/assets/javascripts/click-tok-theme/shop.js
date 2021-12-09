$(document).ready(function() {
  $('.btn-buy').on('click', function() {
    if($(this).hasClass('hidden'))
      return;
    // do work
    $(this).addClass('hidden');
    $(this).parent().append( "<a href='#' class='btn-buy'><i class='fa fa-spinner fa-spin'></i></a>" );
  })
})
