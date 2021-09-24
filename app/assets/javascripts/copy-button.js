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

  $('a.copier').click(function(event){
    event.preventDefault()

    let copiable = $(this).data('copiable')
    let temp_input = $('<input>');

    $('body').append(temp_input);
    temp_input.val(copiable).select();
    document.execCommand('copy');
    temp_input.remove();

    let target = $($(this).data('target'))
    target.addClass('opacity-0')
    setTimeout(function(){
      target.removeClass('opacity-0')
    }, 300)
  });
});
