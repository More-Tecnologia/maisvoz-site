class Score < ApplicationRecord
  include Hashid

  SOURCE_LEGS = [:not_applicable, :left, :right]

  belongs_to :order
  belongs_to :user
  belongs_to :spreader_user, class_name: 'User'
  belongs_to :score_type

  validates :cent_amount, presence: true,
                          numericality: { only_integer: true }
  validates :height, numericality: { only_integer: true }

  enum source_leg: SOURCE_LEGS

  scope :adhesion, -> { where(score_type_id: 1) }
  scope :activation, -> { where(score_type_id: 2) }
  scope :detached, -> { where(score_type_id: 3) }
  scope :by_tree_types, ->(tree_types) { includes(:order, :user, :spreader_user, :score_type)
                                         .joins(:score_type)
                                         .where('score_types.tree_type = ?', tree_types) }
end
