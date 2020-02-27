class DashboardUserDecorator
  def initialize(user)
    @user = user
    @children = @user.unilevel_node.children
    @binary_score = left_binary_score > right_binary_score ? I18n.t(:right) : I18n.t(:left)
  end

  def build
    {
      data: {
        unilevel_counts: unilevel_counts,
        binary_count: binary_count,
        binary_scores: binary_scores
      },
      labels: {
        binary_affiliates_count: I18n.t(:binary_affiliates_count),
        binary_affiliates_left_count: I18n.t(:binary_affiliates_left_count),
        binary_affiliates_right_count: I18n.t(:binary_affiliates_right_count),
        binary_scores: I18n.t(:binary_scores),
        left_binary_score: I18n.t(:left_binary_score),
        right_binary_score: I18n.t(:right_binary_score),
        unilevel_affiliates_count: I18n.t(:unilevel_affiliates_count),
        unilevel_affiliates_actives_count: I18n.t(:unilevel_affiliates_actives_count),
        unilevel_affiliates_inactives_count: I18n.t(:unilevel_affiliates_inactives_count)
      }
    }
  end

  def binary_affiliates_count
    @user.binary_node.descendants.count
  end

  def binary_affiliates_left_count
    return 0 unless @user.binary_node.left_child.present?

    @user.binary_node.left_child.descendants.count + 1
  end

  def binary_affiliates_right_count
    return 0 unless @user.binary_node.right_child.present?

    @user.binary_node.right_child.descendants.count + 1
  end

  def binary_count
    {
      binary_affiliates_count: binary_affiliates_count,
      binary_affiliates_left_count: binary_affiliates_left_count,
      binary_affiliates_right_count: binary_affiliates_right_count
    }
  end

  def binary_scores
    {
      binary_score: @binary_score,
      left_binary_score: left_binary_score,
      right_binary_score: right_binary_score
    }
  end

  def left_binary_score
    @user.binary_node.left_leg_accumulated_score
  end

  def right_binary_score
    @user.binary_node.right_leg_accumulated_score
  end

  def unilevel_counts
    {
      unilevel_affiliates_count: unilevel_affiliates_count,
      unilevel_affiliates_actives_count: unilevel_affiliates_actives_count,
      unilevel_affiliates_inactives_count: unilevel_affiliates_inactives_count
    }
  end

  def unilevel_affiliates_count
    @children.count
  end

  def unilevel_affiliates_actives_count
    @children.includes(:user).where(user: User.active).count
  end

  def unilevel_affiliates_inactives_count
    @children.includes(:user).where(user: User.inactive).count
  end

end
