class Subject < ApplicationRecord
	validates :name, presence: true, uniqueness: true, length: { minimum: 1, maximum: 255 }
	validates :active, presence: true

	has_many :tickets
end
