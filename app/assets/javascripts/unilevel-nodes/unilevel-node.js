$(document).ready(function(){
  $("tr[data-toggle='collapse']").on('shown.bs.collapse', function () {
    icon = selectParentNodeIcon(this)
    icon.removeClass('fa-chevron-down').addClass('fa-chevron-up')
  })

  $("tr[data-toggle='collapse']").on('hidden.bs.collapse', function () {
    icon = selectParentNodeIcon(this)
    icon.removeClass('fa-chevron-up').addClass('fa-chevron-down')
  })

  function selectParentNodeIcon(collapsable) {
    parent_id = $(collapsable).data('parent')
    return $('span#icon-' + parent_id)
  }
})
