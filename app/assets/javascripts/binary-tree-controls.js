$(function () {

  $('[data-binary-tree-top]').click(function () {
    new BinaryTree(window.user_binary_node_id).init();
  });

  $('[data-binary-tree-parent]').click(function () {
    new BinaryTree(window.tree_parent_id).init();
  });

  $('[data-binary-tree-search] button').click(function () {
    var username = $('[data-binary-tree-search] > input').val();
    $.get('/backoffice/binary_tree/search_by_user?username=' + username, function (data) {
      new BinaryTree(data.id).init();
    });
  });

});
