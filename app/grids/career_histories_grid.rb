class CareerHistoriesGrid < BaseGrid

  scope do
    CareerHistory.includes(:user)
  end

  filter(:username, header: I18n.t('attributes.username')) do |value, scope|
    scope.joins(:user).where('users.username ILIKE ?', "%#{value}%")
  end
  filter(:new_career, :enum, select: User::CAREERS.map {|k| [I18n.t(k), k]}, header: I18n.t('attributes.career_kind'))
  filter(:created_at, :date, :range => true, header: I18n.t('attributes.created_at'))

  column(:user, header: I18n.t('attributes.user')) do |r|
    r.user.name
  end
  column(:username, header: I18n.t('attributes.username')) do |r|
    r.user.username
  end
  column(:old_career, header: I18n.t('attributes.old_career'))
  column(:new_career, header: I18n.t('attributes.new_career'))
  date_column(:created_at, header: I18n.t('attributes.created_at'))

end
