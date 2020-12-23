class Interaction < ApplicationRecord
	enum status: Ticket::STATUSES 

	belongs_to :user
	belongs_to :ticket

	has_many_attached :files

	validates :body, presence: true, length: { maximum: 30000 }
	validates :status, presence: true
end
