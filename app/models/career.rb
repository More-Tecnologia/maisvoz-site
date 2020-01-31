# == Schema Information
#
# Table name: careers
#
#  id                               :bigint           not null, primary key
#  name                             :string
#  qualifying_score                 :integer          default(0)
#  bonus                            :integer          default(0)
#  binary_limit                     :integer          default(0)
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  kind                             :integer          default("qualification"), not null
#  binary_percentage                :decimal(5, 2)    default(0.0), not null
#  image_path                       :string
#  requalification_score            :integer
#  unlock_blocked_balance_threshold :decimal(5, 2)
#

class Career < ApplicationRecord

  belongs_to :binary_qualifying_career, class_name: 'Career',
                                        foreign_key: 'career_id',
                                        optional: true
  belongs_to :unilevel_qualifying_career, class_name: 'Career',
                                          optional: true

  has_many :products
  has_many :binary_nodes
  has_many :career_trails
  has_many :trails, through: :career_trails
  has_one :binary_qualified_career, class_name: 'Career',
                                    foreign_key: 'career_id'

  validates :qualifying_score, presence: true,
                               numericality: { only_integer: true },
                               uniqueness: true

  enum kind: [:qualification, :adhesion]

  scope :qualifying, -> { reorder(qualifying_score: :asc) }

  def qualify?(user)
    unilevel_qualify?(user) && binary_qualify?(user)
  end

  def higher?(career)
    higher_qualifying_score?(career) || higher_id?(career)
  end

  def next_career
    Career.where('qualifying_score > ?', qualifying_score).first
  end

  def unilevel_qualify?(user)
    unilevel_qualify_lineages?(user) && user.unilevel_score_sum >= qualifying_score.to_i
  end

  def unilevel_qualify_lineages?(user)
    return true if unilevel_qualifying_career_count.to_i <= 0
    return true if unilevel_qualifying_career.nil?

    qualified_children_count = 0
    user.lineage_scores.each do |child, score|
      qualified_children_count = qualified_children_count + 1 if qualify_lineage?(child, score)
      break if qualified_children_count >= unilevel_qualifying_career_count.to_i
    end
    qualified_children_count >= unilevel_qualifying_career_count.to_i
  end

  def qualify_lineage?(user, score)
    user.current_career.higher_or_equal_to(unilevel_qualifying_career) && score >= lineage_score.to_i
  end

  def binary_qualify?(user)
    return true unless binary_qualifying_career
    user.unilevel_node
        .exists_child_in_greater_binary_leg_by?(binary_qualifying_career)
  end

  def self.detect_requalification_career_trail(user)
    return user.current_career_trail if user.current_career.requalification_score.to_f <= 0.0
    careers = Career.order(requalification_score: :desc)
    user_activation_score = user.scores
                                .activation
                                .by_current_month
                                .sum(:cent_amount)
    career = careers.detect { |c| user_activation_score >= c.requalification_score.to_f }
    career = user.current_career if career.try(:higher?, user.current_career)
    career.career_trails.where(trail: user.current_trail).first
  end

  def higher_or_equal_to(career)
    higher?(career) || self == career
  end

  private

  def higher_qualifying_score?(career)
    qualifying_score > career.qualifying_score
  end

  def higher_id?(career)
    id > career.id
  end

end
