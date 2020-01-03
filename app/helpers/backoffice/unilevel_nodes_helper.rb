module Backoffice
  module UnilevelNodesHelper

    def find_unilevel_node_generation(unilevel_node, current_unilevel_node)
      unilevel_node.depth - current_unilevel_node.depth
    end

    def render_identation(unilevel_node, current_unilevel_node)
      generation = find_unilevel_node_generation(unilevel_node, current_unilevel_node)
      ("&nbsp;&nbsp;&nbsp;" * generation).html_safe
    end

    def render_binary_position(unilevel_node)
      binary_position = unilevel_node.try(:user).try(:binary_position)
      t("attributes.#{binary_position}") if binary_position
    end

    def render_unilvel_node_career(unilevel_node)
      unilevel_node.try(:user).try(:current_career).try(:name)
    end

    def render_unilevel_node_active(unilevel_node)
      active = unilevel_node.try(:user).try(:active?) ? true : false
      I18n.t(active.to_s)
    end

    def render_unilevel_node_html_class(unilevel_node, current_unilevel_node)
      html_class =
        is_first_generation?(unilevel_node, current_unilevel_node) ? '' : 'collapse'
      html_class += " child-of-#{unilevel_node.parent_id}"
    end

    def render_unilevel_node_username(unilevel_node)
      unilevel_node.try(:user).try(:username)
    end

    def render_unilevel_tree_navigation_icon(unilevel_node)
      content_tag :span, '' , class: 'fa fa-chevron-down', id: "icon-#{unilevel_node.id}"
    end

    def unilevel_node_has_children?(unilevel_node)
      ancestry = unilevel_node.ancestry + "/#{unilevel_node.id}"
      unilevel_node_children.has_key?(ancestry)
    end

    def unilevel_node_children
      @unilevel_node_children ||= UnilevelNode.where(ancestry: children_ancestries)
                                              .index_by(&:ancestry)
    end

    private

    def is_first_generation?(unilevel_node, current_unilevel_node)
      find_unilevel_node_generation(unilevel_node, current_unilevel_node) == 1
    end

    def children_ancestries
      @unilevel_nodes.map { |node| node.ancestry + "/#{node.id}" }
    end

  end
end
