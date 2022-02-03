# frozen_string_literal: true

class Review < ApplicationRecord
  include Hashid::Rails

  MAXIMUM_STARS_QUANTITY = 5

  belongs_to :reviewable, polymorphic: true
  belongs_to :user

  has_many :reactions, as: :reactable

  validates :user, uniqueness: { scope: :reviewable }
  validates :stars_quantity, presence: true,
                           numericality: { only_integer: true,
                                           greater_than_or_equal_to: 1,
                                           less_than_or_equal_to: MAXIMUM_STARS_QUANTITY }

  before_save :validate_course_purchase_by_user, if: -> { reviewable_type == 'Course'}

  private

  def validate_course_purchase_by_user
    if reviewable.in?(user.courses)
      return
    else
      errors.add(:base, :buy_course_before_review)
    end
  end
end
