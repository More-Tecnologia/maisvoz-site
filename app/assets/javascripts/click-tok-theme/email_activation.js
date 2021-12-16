$(function(){
  $('a#email-confirmation-btn').click(function(){

    let title = $(this).attr('title')
    let message = $(this).attr('message');
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
