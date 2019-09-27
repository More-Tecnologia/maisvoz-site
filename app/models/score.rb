class Score < ApplicationRecord

  SOURCE_LEGS = [:not_applicable, :left, :right]

  belongs_to :order
  belongs_to :user
  belongs_to :spreader_user, class_name: 'User'
  belongs_to :score_type

  validates :cent_amount, presence: true,
                          numericality: { only_integer: true }
  validates :height, numericality: { only_integer: true }

  enum source_leg: SOURCE_LEGS
end
