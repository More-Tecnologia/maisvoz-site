class Ticket < ApplicationRecord
  include Hashid::Rails

	STATUSES = { waiting: 0, answered: 1, finished: 2 }

	enum status: STATUSES

	belongs_to :subject
	belongs_to :user
	belongs_to :attendant_user, class_name: 'User',
	                            optional: true

	has_many :interactions, dependent: :destroy

	has_many_attached :files

	validates :title, presence: true,
	                  length: { maximum: 255 }
	validates :body, presence: true,
	                 length: { maximum: 30000 }
	validates :status, presence: true

	scope :not_finished, -> { where.not(status: :finished) }
	scope :active, -> { where(active: true) }
  scope :without_attendant_user, -> { where(attendant_user: nil) }
end
