class CareerHistoriesGrid < BaseGrid

  scope do
    CareerHistory.includes(:user)
  end

  filter(:username) do |value, scope|
    scope.joins(:user).where('users.username ILIKE ?', "%#{value}%")
  end
  filter(:new_career, :enum, select: User::CAREERS.map {|k| [I18n.t(k), k]})
  filter(:created_at, :date, :range => true)

  column(:user) do |r|
    r.user.name
  end
  column(:username) do |r|
    r.user.username
  end
  column(:old_career)
  column(:new_career)
  date_column(:created_at)

end
