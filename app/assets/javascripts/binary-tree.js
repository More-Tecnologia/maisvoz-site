var BinaryTree;

$(function() {

  BinaryTree = function BinaryTree(user_binary_node_id) {
    this.$el = $('[data-binary-tree]');
    this.user_binary_node_id = user_binary_node_id;
  }

  BinaryTree.prototype.init = function() {
    this.fetchTree(this.user_binary_node_id);
  }

  BinaryTree.prototype.createTree = function () {
    new Treant(this.getConfig());
    this.registerPopovers();
    this.registerOnClick();
  }

  BinaryTree.prototype.getConfig = function() {
    return {
      chart: {
        container: "#binary-tree",
        connectors: {
          type: "curve",
          style: {
            "stroke-width": 2,
            "stroke-linecap": "round",
            "stroke": "#ccc"
          }
        },
        padding:    50,
        levelSeparation:    25,
        siblingSeparation:  50,
        subTeeSeparation:   50,
        node: {
    			HTMLclass: "tree-node"
    		}
      },
      nodeStructure: this.nodes.root
    };
  }

  BinaryTree.prototype.registerPopovers = function () {
    var thiz = this;

    $('.tree-node').popover({
      trigger: 'hover',
      html: true,
      content: function() {
        var id = $(this).attr('id');
        var html = '';

        var node = thiz.find_node_by_id(id, thiz.nodes.root)

        if (id) {
          html += 'Sponsor: <strong>' + node.sponsor + '</strong><br />';
          html += 'Username: <strong>' + node.username + '</strong><br />';
          html += 'Career: <strong>' + (node.career || '-') + '</strong><br />';
          html += 'Left PV: <strong>' + node.left_pv + '</strong><br />';
          html += 'Right PV: <strong>' + node.right_pv + '</strong>';
        } else {
          html = 'no data';
        }

        return html;
      }
    });
  }

  BinaryTree.prototype.find_node_by_id = function(id, rootNode) {
    if (rootNode == null) { return false }
    if (rootNode.children == null) { return false }
    if (rootNode.HTMLid == id) { return rootNode.data }

    var left  = this.find_node_by_id(id, rootNode.children[0]);
    var right = this.find_node_by_id(id, rootNode.children[1]);

    return left ? left : right;
  }

  BinaryTree.prototype.registerOnClick = function () {
    var thiz = this;

    $('.tree-node').click(function () {
      var id = $(this).attr('id');
      thiz.fetchTree(id);
    });
  }

  BinaryTree.prototype.fetchTree = function(id) {
    if (id) {
      var thiz = this;
      $.get('/backoffice/binary_tree/' + id, function(data) {
        thiz.nodes = data.nodes;
        window.tree_parent_id = data.parent_id;
        thiz.createTree();
      });
    }
  }


  $("[data-binary-tree]").each(function() {
    new BinaryTree(window.user_binary_node_id).init();
  })
})
