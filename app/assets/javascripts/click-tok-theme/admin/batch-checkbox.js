$('document').ready(function() {
  $('input[type=checkbox].parent').on('click', function() {
    var parent_status = $(this).prop('checked')

    $('input[type=checkbox].child').prop('checked', parent_status)
  })

  $('input[type=checkbox].parent, input[type=checkbox].child').on('click', function() {
    if(any_checkbox_child_checked()) {
      $('button.batch-actions').removeClass('disabled')
    }else {
      $('button.batch-actions').addClass('disabled')
    }
    add_selected_withdrawal_ids_to_batch_actions_links()
  })

  function any_checkbox_child_checked() {
    return $('input[type=checkbox].child:checked').length > 0
  }

  function add_selected_withdrawal_ids_to_batch_actions_links() {
    var selected_withdrawal_ids = []
    $('input[type=checkbox].child:checked').each(function(i, checkbox){
      selected_withdrawal_ids.push(checkbox.value)
    })

    $('a.batch-action').each(function(i, action_link){
      var url = $(action_link).data('url') + "&ids=" + selected_withdrawal_ids.join(',')
      $(action_link).prop('href', url)
    })
  }
})
