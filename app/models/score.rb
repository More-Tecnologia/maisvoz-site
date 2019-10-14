class Score < ApplicationRecord
  include Hashid::Rails

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
  scope :includes_associations, -> { includes(:order, :user, :spreader_user, :score_type) }
  scope :binary_by_user, ->(user) { includes_associations.where(user: user,
                                                                score_type: ScoreType.binary) }
  scope :unilevel_by_user, ->(user) { includes_associations.where(user: user,
                                                                  score_type: ScoreType.unilevel) }
  scope :sum_by_generation, -> { where('height > 1')
                                .group(:height)
                                .sum(:cent_amount) }
end
