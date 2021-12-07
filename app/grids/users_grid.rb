class UsersGrid < BaseGrid
  scope do
    User.includes(:sponsor, :career)
        .order(id: :desc)
  end

  decorate(&:decorate)

  filter(:username, header: I18n.t('attributes.user')) do |value, scope|
    scope.where('users.username ILIKE ?', "%#{value.to_s.downcase.strip}%")
  end
  filter(:name, header: I18n.t('attributes.name')) do |value, scope|
    scope.where('users.name ILIKE ?', "%#{value.to_s.downcase.strip}%")
  end
  filter(:email) do |email|
    where('users.email ILIKE ?', "%#{email.to_s.downcase.strip}%")
  end
  filter(:role, :enum, select: User.roles, header: I18n.t('attributes.role'))
  filter(:role_type_code, :enum, select: RoleType.order(:name).pluck(:name, :code), header: I18n.t('attributes.role_type'))
  filter(:career, :enum, select: Career.qualifying.pluck(:name, :id), header: I18n.t('attributes.career_kind'))
  filter(:trail, :enum, select: Trail.pluck(:name, :id), header: I18n.t('attributes.trail'))
  filter(:active, :xboolean, header: I18n.t('attributes.active')) do |value|
     value == true ? merge(User.active) : merge(User.inactive)
  end
  filter(:master_leader, :xboolean, header: I18n.t(:master_leader)) do |value|
     value == true ? merge(User.master_leaders) : merge(User.not_master_leaders)
  end
  filter(:created_at, :date, :range => true, header: I18n.t('attributes.created_at'))
  filter(:binary_qualified, :xboolean, header: I18n.t('attributes.binary_qualify')) if ENV['ENABLED_BINARY'] == 'true'

  column_names_filter(header: I18n.t(:additional_columns), checkboxes: true)

  column(:id, mandatory: true)
  column(:email, mandatory: true, header: ' ' + I18n.t(:email))
  column(:pretty_username, mandatory: true, header: I18n.t('attributes.user'))
  column(:sponsor_username, mandatory: true, header: I18n.t('attributes.sponsor')) do |user|
    user.try(:sponsor).try(:username)
  end
  column(:activity, html: true, mandatory: true, header: I18n.t('attributes.activity'))
  column(:qualification, html: true, mandatory: true, header: I18n.t('attributes.qualification')) if ENV['ENABLED_BINARY'] == 'true'
  column(:career_name, mandatory: true, header: I18n.t('attributes.career_kind'))
  column(:created_at, html: false, mandatory: true, header: I18n.t('attributes.created_at'))
  column(:created_at, header: ' ' + I18n.t('attributes.created_at')) do |user|
    format(user.created_at) do |created_at|
      l(created_at, format: '%B %d, %Y')
    end
  end
  column(:block, mandatory: true, header: I18n.t('attributes.blocked'), class: 'text-center') do |user|
    format(user) do |user|
      render_blocked_user_attribute_link(user)
    end
  end
  column(:canceled, mandatory: true, header: I18n.t('attributes.canceled'), class: 'text-center') do |user|
    format(user) do |user|
      render_canceled_user_attribute_link(user)
    end
  end
  column :actions, mandatory: true, header: I18n.t('backoffice.support.users.index.actions') do |user|
    format(user) do
      [
        link_to(backoffice_support_user_path(user), title: I18n.t(:see_profile)) { content_tag(:i, nil, class: 'fa fa-user m-r-5 ') },
        link_to(backoffice_admin_financial_transactions_path('q[user_username_cont]' => user.username), title: I18n.t(:financial_history)) { content_tag(:i, nil, class: 'fa fa-dollar m-r-5 text-success') },
        link_to(edit_backoffice_support_user_path(user), title: I18n.t(:edit_user)) { content_tag(:i, nil, class: 'fa fa-edit m-r-5 text-warning') },
        link_to(masquerade_path(user), title: I18n.t(:enter_as_user)) { content_tag(:i, nil, class: 'fas fa-sign-in-alt text-danger') }
      ].join.html_safe
    end
  end
  column(:gender, header: ' ' + I18n.t(:gender))
  column(:phone, header: ' ' + I18n.t(:phone))
  column(:registration_type, header: ' ' + I18n.t(:registration_type))
  column(:document_rg, header: ' ' + I18n.t(:passport))
  column(:document_cpf, header:' ' + I18n.t(:id))
  column(:birthdate, header: ' ' + I18n.t(:birthdate))
end
