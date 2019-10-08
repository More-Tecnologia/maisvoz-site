class CareerHistoriesGrid < BaseGrid

  scope do
    CareerTrailUser.includes(:user, career_trail: [:career, :trail]).joins(:user)
  end

  filter(:username, header: I18n.t('attributes.username')) do |value, scope|
    scope.where('users.username ILIKE ?', "%#{value}%")
  end
  filter(:email, header: I18n.t('attributes.email')) do |value, scope|
    scope.where('users.email ILIKE ?', "%#{value}%")
  end

  column(:username, header: I18n.t('attributes.username')) do |r|
    r.user.username
  end
  column(:career, header: I18n.t('attributes.career')) do |r|
    r.career_trail.career.name
  end
  column(:trail, header: I18n.t('attributes.trail')) do |r|
    r.career_trail.trail.name
  end
  column(:created_at, header: I18n.t('attributes.created_at')) do |r|
    r.created_at.strftime('%d/%m/%Y')
  end
end
