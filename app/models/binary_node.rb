class BinaryNode < ApplicationRecord

  include Hashid::Rails

  has_ancestry

  belongs_to :user
  belongs_to :left_child, class_name: 'BinaryNode',
                          optional: true
  belongs_to :right_child, class_name: 'BinaryNode',
                           optional: true

  scope :includes_associations, -> { includes(:left_child, :right_child, user: [:sponsor]) }

  def find_leg(child)
    return :left if left_child?(child)
    return :right if right_child?(child)
  end

  def is_shortter_leg?(leg)
    leg == shortter_leg
  end

  def shortter_leg
    left_leg_score <= right_leg_score ? :left : :right
  end

  def shortter_leg_score
    left_leg_score <= right_leg_score ? left_leg_score : right_leg_score
  end

  def left_leg_score
    user.scores.binary.left.sum(:cent_amount)
  end

  def right_leg_score
    user.scores.binary.right.sum(:cent_amount)
  end

  def left_child?(child)
    child == left_child
  end

  def right_child?(child)
    child == right_child
  end

  def reached_minimum_score_paid?
    shortter_leg_score >= ENV['BINARY_SCORE_MINIMUM_PAID'].to_i
  end

  def calculate_unqualified_score(new_score)
    total_score = shortter_leg_score + new_score
    total_score - ENV['UNQUALIFIED_LIMIT_SCORE'].to_f
  end

  def reached_minimum_score_paid_ancestors
    ancestors.select(&:reached_minimum_score_paid?)
  end

  def left_leg_qualified?
    user.sponsored.left.exists?(active: true)
  end

  def right_leg_qualified?
    user.sponsored.right.exists?(active: true)
  end

  def qualified?
    right_leg_qualified? && left_leg_qualified?
  end

  def qualifier?(trail)
    user.active && user.current_trail.greater_or_equal_to?(trail)
  end

  def source_leg_accumulated_score
    return left_leg_accumulated_score if user.left?
    right_leg_accumulated_score if user.right?
  end

  def work_leg_accumulated_score
    return left_leg_accumulated_score if user.right?
    right_leg_accumulated_score if user.left?
  end

  def left_leg_accumulated_score
    user.scores.left.binary_qualification.sum(:cent_amount)
  end

  def right_leg_accumulated_score
    user.scores.right.binary_qualification.sum(:cent_amount)
  end

  def source_leg
    user.binary_position
  end

  def work_leg
    (User.binary_positions.keys - [source_leg]).first
  end

  def shortter_leg_accumulated_score
    [left_leg_accumulated_score, right_leg_accumulated_score].min
  end

end
