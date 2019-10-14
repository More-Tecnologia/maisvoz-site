# == Schema Information
#
# Table name: careers
#
#  id                :bigint(8)        not null, primary key
#  name              :string
#  qualifying_score  :integer          default(0)
#  bonus             :integer          default(0)
#  binary_limit      :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  kind              :integer          default("qualification"), not null
#  binary_percentage :decimal(5, 2)    default(0.0), not null
#  image_path        :string
#

class Career < ApplicationRecord

  scope :qualifying, -> { reorder(qualifying_score: :asc) }

  enum kind: [:qualification, :adhesion]

  has_many :products
  has_many :binary_nodes
  has_many :career_trails
  has_many :trails, through: :career_trails

  validates :requalification_score, presence: true,
                                    numericality: { only_integer: true },
                                    uniqueness: true

  def qualify?(user)
    user.scores.sum(&:cent_amount).to_i >= qualifying_score
  end

  def higher?(career)
    higher_qualifying_score?(career) || higher_id?(career)
  end

  def next_career
    Career.where('qualifying_score > ?', qualifying_score).first
  end

  private

  def higher_qualifying_score?(career)
    qualifying_score > career.qualifying_score
  end

  def higher_id?(career)
    id > career.id
  end
end
