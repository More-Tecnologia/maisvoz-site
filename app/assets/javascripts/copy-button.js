$(function(){
  $('.copy-trigger').click(function(){
    var temp = $('<input>');
    var copyable_id = $(this).data('copyable');
    var text = $(copyable_id).text();

    $('body').append(temp);
    temp.val(text).select();
    document.execCommand('copy');
    temp.remove();
  });
});
