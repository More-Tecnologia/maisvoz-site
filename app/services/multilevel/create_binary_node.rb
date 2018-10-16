module Multilevel
  class CreateBinaryNode

    LEFT = :left
    RIGHT = :right

    def initialize(user)
      @user    = user
      @sponsor = user.sponsor
    end

    def call
      return if user.binary_node.present?
      define_position
      find_parent_node

      parent_node.with_lock do
        insert_node
        update_parent_node
        update_user_binary_position
        update_parent_counters
      end
    end

    private

    attr_reader :user, :sponsor, :position, :parent_node

    def update_parent_counters
      parent = binary_node.parent
      curr_id = binary_node.id
      while parent.present?
        parent.increment!(:left_count) if parent.left_child_id == curr_id
        parent.increment!(:right_count) if parent.right_child_id == curr_id

        curr_id = parent.id
        parent = parent.parent
      end
    end

    def update_user_binary_position
      if position == LEFT
        user.left!
      else
        user.right!
      end
    end

    def update_parent_node
      if position == LEFT
        parent_node.update!(left_child: binary_node)
      else
        parent_node.update!(right_child: binary_node)
      end
    end

    def insert_node
      binary_node.save!
    end

    def find_parent_node
      if position == LEFT
        @parent_node = find_left_node(sponsor.binary_node)
      elsif position == RIGHT
        @parent_node = find_right_node(sponsor.binary_node)
      else
        raise 'unable to find a position for the binary'
      end
    end

    def find_left_node(node)
      while node.left_child.present?
        node = node.left_child
      end
      node
    end

    def find_right_node(node)
      while node.right_child.present?
        node = node.right_child
      end
      node
    end

    # Defines the position in which the user will be inserted on the binary node
    # First it checks to see if the sponsor has defined a position for him (@binary_position)
    #
    # If not defined, it checks to see if there is a left/right general strategy
    # defined, and if not, it'll assume it's the balanced strategy.
    #
    # In the balanced strategy, it'll check if there is some other direct sponsored user
    # and then follow from there, if not, it'll follow the position of its sponsor
    def define_position
      if user.binary_position.present?
        @position = user.left? ? LEFT : RIGHT
      elsif sponsor.left_strategy? || sponsor.right_strategy?
        @position = sponsor.left_strategy? ? LEFT : RIGHT
      else
        @position = balanced_position
      end
    end

    def balanced_position
      if last_sponsored_user.present?
        last_sponsored_user.left? ? RIGHT : LEFT
      else
        sponsor.left? ? LEFT : RIGHT
      end
    end

    def last_sponsored_user
      @last_sponsored_user ||= LastActiveSponsoredUserQuery.new(sponsor).call
    end

    def binary_node
      @binary_node ||= BinaryNode.new.tap do |node|
        node.user         = user
        node.sponsored_by = sponsor
        node.parent       = parent_node
      end
    end

  end
end
