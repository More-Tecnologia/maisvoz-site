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
  scope :activation, -> { where(score_type: ScoreType.activation) }
  scope :detached, -> { where(score_type_id: 3) }
  scope :includes_associations, -> { includes(:order, :user, :spreader_user, :score_type) }
  scope :chargeback, -> { where('cent_amount < 0') }
  scope :not_chargeback, -> { where('cent_amount >= 0') }
  scope :binary_score, -> { where(score_type: ScoreType.binary_score ) }
  scope :binary_by_user, ->(user) { includes_associations.where(user: user,
                                                                score_type: ScoreType.binary) }
  scope :unilevel_by_user, ->(user) { includes_associations.where(user: user,
                                                                  score_type: ScoreType.unilevel) }
  scope :binary, -> { where(score_type: ScoreType.binary) }
  scope :unilevel, -> { where(score_type: ScoreType.unilevel) }
  scope :accumulate, -> { where(score_type: ScoreType.unilevel) }
  scope :sum_unilevel_received_by, ->(user_ids) { unilevel.where(user_id: user_ids)
                                                          .group(:user)
                                                          .sum(:cent_amount) }
  scope :sum_unilevel_spreaded_by, ->(user_ids) { unilevel.where(spreader_user_id: user_ids)
                                                          .group(:spreader_user)
                                                          .sum(:cent_amount) }
  scope :by_current_month,
    -> { where(created_at: (Date.current.beginning_of_month..Date.current.end_of_month)) }
  scope :spreaded_to, ->(user) { where(user: user) }
  scope :binary_qualification, -> { where(score_type: ScoreType.binary_score) }
  scope :by_date, ->(date) { where(created_at: (date.beginning_of_day..date.end_of_day)) }
  scope :pool_point_by, ->(order) { where(order: order, score_type: ScoreType.pool_point) }

  after_commit :upgrade_user_career, on: :create

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

  def self.unilevel_scores_by_lineage(user, q = Score.ransack)
    children_ids = user.unilevel_node
                       .children
                       .pluck(:user_id)
    received_scores = q.result
                       .sum_unilevel_received_by(children_ids)
    spreaded_scores_from_children = q.result
                                     .spreaded_to(user)
                                     .sum_unilevel_spreaded_by(children_ids)
    lineage_scores =
      sum_scores_by_user(received_scores, spreaded_scores_from_children).to_a
                                                                        .sort_by(&:second)
                                                                        .reverse
    Score.sum_scores_by_user(received_scores, spreaded_scores_from_children)
  end

  def self.sum_scores_by_user(received_scores, spreaded_scores)
    received_scores.merge(spreaded_scores) { |key, old, new| old + new }
  end

  def active?
    return true if expire_at.nil?
    expire_at > Time.now
  end

  private

  def upgrade_user_career
    UpgraderCareerService.call(user: user)
  end

  def score_type_is_binary_bonus?
    score_type == ScoreType.binary_score
  end

end
