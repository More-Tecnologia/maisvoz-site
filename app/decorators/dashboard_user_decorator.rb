class DashboardUserDecorator
  def initialize(user)
    @user = user
    @binary_score = left_binary_score > right_binary_score ? I18n.t(:right) : I18n.t(:left)
  end

  def build
    {
      data: {
        binary_count: binary_count,
        binary_scores: binary_scores
      },
      labels: {
        binary_affiliates_count: I18n.t(:binary_affiliates_count),
        binary_affiliates_left_count: I18n.t(:binary_affiliates_left_count),
        binary_affiliates_right_count: I18n.t(:binary_affiliates_right_count),
        binary_scores: I18n.t(:binary_scores),
        left_binary_score: I18n.t(:left_binary_score),
        right_binary_score: I18n.t(:right_binary_score)
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
end
