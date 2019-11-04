# == Schema Information
#
# Table name: binary_nodes
#
#  id              :bigint(8)        not null, primary key
#  user_id         :bigint(8)        not null
#  sponsored_by_id :bigint(8)
#  parent_id       :bigint(8)
#  left_child_id   :bigint(8)
#  right_child_id  :bigint(8)
#  left_pv         :bigint(8)        default(0)
#  right_pv        :bigint(8)        default(0)
#  left_count      :bigint(8)        default(0)
#  right_count     :bigint(8)        default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_binary_nodes_on_left_child_id    (left_child_id)
#  index_binary_nodes_on_parent_id        (parent_id)
#  index_binary_nodes_on_right_child_id   (right_child_id)
#  index_binary_nodes_on_sponsored_by_id  (sponsored_by_id)
#  index_binary_nodes_on_user_id          (user_id) UNIQUE
#

class BinaryNode < ApplicationRecord

  include Hashid::Rails

  belongs_to :user
  belongs_to :left_child, class_name: 'BinaryNode',
                          optional: true
  belongs_to :right_child, class_name: 'BinaryNode',
                           optional: true

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
    user.scores.binary_score.left.sum(:cent_amount)
  end

  def right_leg_score
    user.scores.binary_score.right.sum(:cent_amount)
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

end
