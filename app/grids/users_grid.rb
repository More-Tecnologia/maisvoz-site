class UsersGrid < BaseGrid

  scope do
    User.all.order(id: :desc)
  end

  decorate {|user| user.decorate }

  filter(:username, header: I18n.t('attributes.username')) do |value, scope|
    scope.where('users.username ILIKE ?', "%#{value}%")
  end
  filter(:name, header: I18n.t('attributes.name')) do |value, scope|
    scope.where('users.name ILIKE ?', "%#{value}%")
  end
  filter(:document_cpf, header: I18n.t('attributes.document_cpf'))
  filter(:email)
  filter(:role, :enum, select: User.roles, header: I18n.t('attributes.role'))
  filter(:active, :xboolean, header: I18n.t('attributes.active'))
  filter(:created_at, :date, :range => true, header: I18n.t('attributes.created_at'))
  filter(:binary_qualified, :xboolean, header: I18n.t('attributes.binary_qualify'))

  column_names_filter(:header => "Colunas Extras", checkboxes: true)

  column(:id, mandatory: true)
  column(:pretty_name, mandatory: true, header: I18n.t('attributes.username'))
  column(:sponsor_username, mandatory: true, header: I18n.t('attributes.sponsor')) do |user|
    user.try(:sponsor).try(:username)
  end
  column(:pretty_name, mandatory: true, header: I18n.t('attributes.user'))
  column(:main_document, mandatory: true, header: I18n.t('attributes.main_document'))
  column(:activity, html: true, mandatory: true, header: I18n.t('attributes.activity'))
  column(:qualification, html: true, mandatory: true, header: I18n.t('attributes.qualification'))
  column(:career_name, mandatory: true, header: I18n.t('attributes.career_kind'))
  column(:trail_name, mandatory: true, header: I18n.t('attributes.trail'))
  column(:created_at, html: false, mandatory: true, header: I18n.t('attributes.created_at'))
  column(:created_at, header: I18n.t('attributes.created_at')) do |user|
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
        link_to(backoffice_admin_bonus_financial_transactions_path(username: user.username), title: 'Histórico de Bônus') { content_tag(:i, nil, class: 'fa fa-star m-r-5') },
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

  column(:gender)
  column(:email)
  column(:phone)
  column(:registration_type)
  column(:document_cpf)
  column(:document_rg)
  column(:document_pis)
  column(:document_cnpj)
  column(:document_ie)
  column(:document_company_name)
  column(:document_fantasy_name)
  column(:birthdate)

end
