class ClubMotorsSubscriptionsGrid < BaseGrid

  scope do
    ClubMotorsSubscription.includes(:user).includes(car_model: :car_brand)
  end

  filter(:id, :integer)
  filter(:plate, :string)

  column(:id)
  column(:name)
  column(:plate)
  column(:status) do |s|
    format(s.status) do |value|
      css_class = 'badge-danger'
      if s.active?
        css_class = 'badge-success'
      elsif s.past_due?
        css_class = 'badge-warning'
      end
      content_tag(:span, t(value), class: ['badge', css_class])
    end
  end
  column(:username) do |s|
    format(s.user) do |value|
      link_to_user(value)
    end
  end
  date_column(:created_at)
  column(:details) do |s|
    format(s) do |value|
      link_to('Detalhe', backoffice_admin_club_motors_subscription_path(value))
    end
  end
end
