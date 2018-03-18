$(document).ready(function () {
  var filtering = $('#table-filtering');
  filtering.footable().on('footable_filtering');

  // Search input
  $('#table-search').on('input', function (e) {
      e.preventDefault();
      filtering.trigger('footable_filter', {filter: $(this).val()});
  });
})
