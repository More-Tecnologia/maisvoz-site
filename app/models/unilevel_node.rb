# == Schema Information
#
# Table name: unilevel_nodes
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)        not null
#  username    :string
#  career_kind :string
#  leader      :boolean          default(FALSE), not null
#  ancestry    :string(300)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_unilevel_nodes_on_ancestry  (ancestry)
#  index_unilevel_nodes_on_user_id   (user_id) UNIQUE
#

class UnilevelNode < ApplicationRecord

  belongs_to :user

  has_ancestry cache_depth: true

  scope :binary_position_left, -> { joins(:user).merge(User.left) }
  scope :binary_position_right, -> { joins(:user).merge(User.right) }
  scope :includes_users, -> { includes(user: [career_trail_users: [career_trail: [trail: [:product]]]]) }
  scope :bonus_receivers, ->(count) { includes_users.last(count) }
  scope :dynamic_compression, ->(count) { includes_users.joins(:user)
                                                        .merge(User.active)
                                                        .last(count) }

  def left_descendants_count
    @left_descendants_count ||= descendants.binary_position_left.count
  end

  def right_descendants_count
    @right_descendants_count ||= descendants.binary_position_right.count
  end

  def right_leg_greater?
    right_descendants_count.to_i > left_descendants_count.to_i
  end

  def left_leg_greater?
    left_descendants_count.to_i > right_descendants_count.to_i
  end

  def legs_equal_length?
    right_descendants_count.to_i == left_descendants_count.to_i
  end

  def find_greater_leg_children
    return descendants if legs_equal_length?
    return descendants.binary_position_right if right_leg_greater?
    return descendants.binary_position_left if left_leg_greater?
    []
  end

  def exists_child_in_greater_binary_leg_by?(career)
    CareerTrailUser.order(created_at: :desc).exists?(user: find_greater_leg_children,
                                                     career_trail: career.career_trails)
  end

end
