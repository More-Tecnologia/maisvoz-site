# frozen_string_literal: true

class Categorization < ApplicationRecord
  has_many :item_categorizations
  has_many :itemables, through: :item_categorizations

  validates :tag, presence: true
  validates :title, presence: true
end
