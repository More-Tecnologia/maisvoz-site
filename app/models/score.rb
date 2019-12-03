class Score < ApplicationRecord
  include Hashid::Rails

  SOURCE_LEGS = [:not_applicable, :left, :right]

  has_one :chargeback, class_name: 'Score'

  belongs_to :order, optional: true
  belongs_to :user
  belongs_to :spreader_user, class_name: 'User', optional: true
  belongs_to :score_type
  belongs_to :score, optional: true

  validates :cent_amount, presence: true,
                          numericality: { only_integer: true }
  validates :height, numericality: { only_integer: true }, allow_nil: -> { score_type_is_binary_bonus_debit? }

  enum source_leg: SOURCE_LEGS

  scope :adhesion, -> { where(score_type_id: 1) }
  scope :activation, -> { where(score_type_id: 2) }
  scope :detached, -> { where(score_type_id: 3) }
  scope :includes_associations, -> { includes(:order, :user, :spreader_user, :score_type) }
  scope :chargeback, -> { where('cent_amount < 0') }
  scope :not_chargeback, -> { where('cent_amount >= 0') }
  scope :binary_score, -> { where(score_type: ScoreType.binary_score ) }
  scope :binary_by_user, ->(user) { includes_associations.where(user: user,
                                                                score_type: ScoreType.binary) }
  scope :unilevel_by_user, ->(user) { includes_associations.where(user: user,
                                                                  score_type: ScoreType.unilevel) }
  scope :sum_by_generation, -> { where('height > 1')
                                .group(:height)
                                .sum(:cent_amount) }
  scope :binary, -> { where(score_type: ScoreType.binary) }
  scope :accumulate, -> { where.not(score_type: ScoreType.binary_bonus_debit) }

  def chargeback!(score_type, amount = cent_amount)
    create_chargeback!(source_leg: source_leg,
                       order: order,
                       user: user,
                       spreader_user: order.user,
                       cent_amount: -(amount.abs.to_i),
                       height: height,
                       score_type: score_type)
  end

  def chargeback_by_inactivity!
    chargeback!(ScoreType.unilevel_inactivity_chargeback)
  end

  def self.debit_binary_score_from_legs(user, score)
    attrs = { user: user,
              cent_amount: -(score.to_i.abs),
              score_type: ScoreType.binary_bonus_debit }
    left_leg_attrs = attrs.merge(source_leg: :left)
    right_leg_attrs = attrs.merge(source_leg: :right)

    create!(left_leg_attrs)
    create!(right_leg_attrs)
  end

  def score_type_is_binary_bonus_debit?
    binary_bonus_debit = ScoreType.binary_bonus_debit
    binary_bonus_debit && binary_bonus_debit == score_type
  end

end
