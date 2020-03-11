class UsersGrid < BaseGrid

  scope do
    User.includes(:sponsor, :support_point_user, :career, :trail)
        .order(id: :desc)
  end

  decorate(&:decorate)

  filter(:username, header: I18n.t('attributes.user')) do |value, scope|
    scope.where('users.username ILIKE ?', "%#{value}%")
  end
  filter(:name, header: I18n.t('attributes.name')) do |value, scope|
    scope.where('users.name ILIKE ?', "%#{value}%")
  end
  filter(:document_cpf, header: I18n.t('attributes.document_cpf'))
  filter(:email)
  filter(:role, :enum, select: User.roles, header: I18n.t('attributes.role'))
  filter(:role_type_code, :enum, select: RoleType.order(:name).pluck(:name, :code), header: I18n.t('attributes.role_type'))
  filter(:active, :xboolean, header: I18n.t('attributes.active')) do |value|
     value == true ? merge(User.active) : merge(User.inactive)
  end
  filter(:created_at, :date, :range => true, header: I18n.t('attributes.created_at'))
  filter(:binary_qualified, :xboolean, header: I18n.t('attributes.binary_qualify')) if ENV['ENABLED_BINARY'] == 'true'

  column_names_filter(:header => "Colunas Extras", checkboxes: true)

  column(:id, mandatory: true)
  column(:pretty_username, mandatory: true, header: I18n.t('attributes.user'))
  column(:pretty_name, mandatory: true, header: I18n.t('attributes.username'))
  column(:sponsor_username, mandatory: true, header: I18n.t('attributes.sponsor')) do |user|
    user.try(:sponsor).try(:username)
  end
  column(:support_point_pretty_name, mandatory: true, header: I18n.t('attributes.support_point_user'))
  column(:main_document, mandatory: true, header: I18n.t('attributes.main_document'))
  column(:activity, html: true, mandatory: true, header: I18n.t('attributes.activity'))
  column(:qualification, html: true, mandatory: true, header: I18n.t('attributes.qualification')) if ENV['ENABLED_BINARY'] == 'true'
  column(:career_name, mandatory: true, header: I18n.t('attributes.career_kind'))
  column(:trail_name, mandatory: true, header: I18n.t('attributes.trail'))
  column(:created_at, html: false, mandatory: true, header: I18n.t('attributes.created_at'))
  column(:created_at, header: ' ' + I18n.t('attributes.created_at')) do |user|
    format(user.created_at) do |created_at|
      l(created_at, format: :short)
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
        link_to(backoffice_support_user_path(user), title: 'Ver perfil') { content_tag(:i, nil, class: 'fa fa-user m-r-5') },
        link_to(backoffice_admin_financial_transactions_path('q[user_username_cont]' => user.username), title: 'Histórico Financeiro') { content_tag(:i, nil, class: 'fa fa-dollar m-r-5') },
        link_to(backoffice_admin_pv_activity_histories_path(username: user.username), title: 'Histórico PV Atividade') { content_tag(:i, nil, class: 'fa fa-plus-square m-r-5') },
        link_to(backoffice_admin_pv_histories_path(username: user.username), title: 'Histórico PVs') { content_tag(:i, nil, class: 'fa fa-clock-o m-r-5') },
        link_to(edit_backoffice_support_user_path(user), title: 'Editar Usuário') { content_tag(:i, nil, class: 'fa fa-edit m-r-5') }
      ].join.html_safe
    end
  end
  column(:sign_in, mandatory: true, header: I18n.t('backoffice.support.users.index.sign_in')) do |user|
    format(user) do |user|
      if current_user.admin?
        link_to(masquerade_path(user), title: 'Logar como Usuário') { content_tag(:i, nil, class: 'fa fa-user') }
      end
    end
  end

  column(:gender, header: ' ' + I18n.t(:gender))
  column(:email, header: ' ' + I18n.t(:email))
  column(:phone, header: ' ' + I18n.t(:phone))
  column(:registration_type, header: ' ' + I18n.t(:registration_type))
  column(:document_rg, header: ' ' + I18n.t(:passport))
  column(:document_cpf, header:' ' + I18n.t(:id))
  column(:birthdate, header: ' ' + I18n.t(:birthdate))

end
