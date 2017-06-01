class CategoryForm < Form

  attribute :name
  attribute :description
  attribute :order
  attribute :active_session
  attribute :active

  validates :name, presence: true

end
