$(document).ready(function(){
  $("tr[data-toggle='collapse']").on('shown.bs.collapse', function () {
    glyphicon = selectParentNodeIcon(this)
    glyphicon.removeClass('glyphicon-chevron-down')
             .addClass('glyphicon-chevron-up')
  })

  $("tr[data-toggle='collapse']").on('hidden.bs.collapse', function () {
    glyphicon = selectParentNodeIcon(this)
    glyphicon.removeClass('glyphicon-chevron-up')
             .addClass('glyphicon-chevron-down')
  })

  function selectParentNodeIcon(collapsable) {
    parent_id = $(collapsable).data('parent')
    return $('span#icon-' + parent_id)
  }
})
