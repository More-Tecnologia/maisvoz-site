# frozen_string_literal: true

class ItemCategorization < ApplicationRecord
  belongs_to :categorizations
  belongs_to :itemable, polymorphic: true
end
