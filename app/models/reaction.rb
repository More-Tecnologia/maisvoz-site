# frozen_string_literal: true

class Reaction < ApplicationRecord
  enum emotion: { like: 0, dislike: 1 }

  belongs_to :reactable, polymorphic: true
  belongs_to :user

  validates :user, uniqueness: { scoped_to: :reactable }
  validates :emotion, presence: true
end
