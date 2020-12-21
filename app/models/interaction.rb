class Interaction < ApplicationRecord
	enum status: Ticket::STATUSES 

	belongs_to :user
	belongs_to :ticket

	validates :body, presence: true, length: { maximum: 30000 }
	validates :active, presence: true
end
