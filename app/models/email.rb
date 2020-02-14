class Email < ApplicationRecord
  include Hashid::Rails

  enum status: { pending: 0, active: 1, inactive: 2 }

  belongs_to :user

  validates :body, presence: true, email: true, uniqueness: { if: :any_active? }

  after_update :change_user_email, if: :active?
  after_update :inactive_emails, if: :active?

  def change_user_email
    user.update(email: body)
  end

  def inactive_emails
    other_user_emails.each(&:inactivate!)
  end

  def any_active?
    self.class.where(body: body, status: 1).any?
  end

  def other_user_emails
    user.emails - [self]
  end

  def inactivate!
    update_attribute(:status, :inactive)
  end
end
