# frozen_string_literal: true

class Categorization < ApplicationRecord
  include Hashid::Rails
  has_many :item_categorizations
  has_many :itemables, through: :item_categorizations

  validates :tag, presence: true
  validates :title, presence: true

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where.not(Categorization.active.where_values_hash)}
end
