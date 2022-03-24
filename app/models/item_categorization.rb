# frozen_string_literal: true

class ItemCategorization < ApplicationRecord
  belongs_to :categorization
  belongs_to :itemable, polymorphic: true
end
