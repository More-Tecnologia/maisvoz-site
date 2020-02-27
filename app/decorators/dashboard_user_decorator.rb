class DashboardUserDecorator
  def initialize(user)
    @user = user
    @binary_score = left_binary_score > right_binary_score ? I18n.t(:right) : I18n.t(:left)
  end

  def build
    {
      data: {
        binary_scores: binary_scores
      },
      labels: {
        binary_scores: I18n.t(:binary_scores),
        left_binary_score: I18n.t(:left_binary_score),
        right_binary_score: I18n.t(:right_binary_score)
      }
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
