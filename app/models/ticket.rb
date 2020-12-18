class Ticket < ApplicationRecord
	STATUSES = { waiting: 0, answered: 1, finished: 2 }
	
	enum status: STATUSES

	belongs_to :subject
	belongs_to :user
	belongs_to :attendant_user, class_name: 'User'
	
	validates :title, presence: true, length: { maximum: 255 }
	validates :body, presence: true, length: { maximum: 30000 }
	validates :active, presence: true
end
