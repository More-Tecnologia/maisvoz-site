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

  enum kind: [:qualification, :adhesion]

  has_many :products
  has_many :binary_nodes
  has_many :users
  has_many :career_trails
  has_many :trails, through: :career_trails
  has_many :product_scores
end
