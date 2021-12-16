$(function(){
  $('a#email-confirmation-btn').click(function(){

    let title = $(this).attr('title')
    let message = $(this).attr('message');
    let nextMessage = $(this).attr('next_message');
    $(this).addClass('hidden');
    $(this).parent().append( `<a href='#' class='btn-red' id='already-send-email-confirmation-btn'>${nextMessage}</a>`);
    Swal.fire(
      title,
      message,
      'success'
    )
  });

  $('a#already-send-email-confirmation-btn').click(function(){

    let title = $(this).attr('title')
    let message = $(this).attr('message');
    Swal.fire(
      title,
      message,
      'warning'
    )
  });
});
