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
    user.unilevel_score_count >= qualifying_score
  end

  def binary_qualify?(user)
    return true unless binary_qualifying_career
    user.unilevel_node
        .exists_child_in_greater_binary_leg_by?(binary_qualifying_career)
  end

  private

  def higher_qualifying_score?(career)
    qualifying_score > career.qualifying_score
  end

  def higher_id?(career)
    id > career.id
  end

end
