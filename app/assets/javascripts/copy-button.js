$(function(){
  $('a#sponsor-link').click(function(){
    let temp = $('<input>');
    let text = $(this).attr('sponsor-link');
    let title = $(this).attr('title')
    let message = $(this).attr('message');

    $('body').append(temp);
    temp.val(text).select();
    document.execCommand('copy');
    temp.remove();
    Swal.fire(
      title,
      message,
      'success'
    )
  });
});
