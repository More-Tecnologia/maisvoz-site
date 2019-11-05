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

  def left_child?(child)
    child == left_child
  end

  def right_child?(child)
    child == right_child
  end

  def calculate_unqualified_score(new_score)
    total_score = shortter_leg_score + new_score
    total_score - ENV['UNQUALIFIED_LIMIT_SCORE'].to_f
  end
end
