class UsersGrid < BaseGrid

  scope do
    User.all.order(id: :desc)
  end

  decorate {|user| user.decorate }

  filter(:username) do |value, scope|
    scope.where('users.username ILIKE ?', "%#{value}%")
  end
  filter(:name) do |value, scope|
    scope.where('users.name ILIKE ?', "%#{value}%")
  end
  filter(:document_cpf)
  filter(:email)
  filter(:role, :enum, select: User.roles)
  filter(:created_at, :date, :range => true)

  column_names_filter(:header => "Colunas Extras", checkboxes: true)

  column(:id, mandatory: true)
  column(:username, html: false, mandatory: true)
  column(:username) do |user|
    format(user) do |obj|
      link_to_user obj
    end
  end
  column(:pretty_name, mandatory: true)
  column(:main_document, mandatory: true)
  column(:activity, html: true, mandatory: true)
  column(:qualification, html: true, mandatory: true)
  column(:pretty_career, mandatory: true)
  column(:created_at, html: false, mandatory: true)
  column(:created_at) do |user|
    format(user.created_at) do |created_at|
      l(created_at, format: :short)
    end
  end
  column :actions, mandatory: true do |user|
    format(user) do
      [
        link_to(backoffice_support_user_path(user), title: 'Ver perfil', target: '_blank') { content_tag(:i, nil, class: 'fa fa-user m-r-5') },
        link_to(backoffice_admin_bonus_entries_path(username: user.username), title: 'Histórico de Bônus', target: '_blank') { content_tag(:i, nil, class: 'fa fa-star m-r-5') },
        link_to(backoffice_admin_financial_entries_path('q[user_username_cont]' => user.username), title: 'Histórico Financeiro', target: '_blank') { content_tag(:i, nil, class: 'fa fa-dollar m-r-5') },
        link_to(backoffice_admin_pv_activity_histories_path(username: user.username), title: 'Histórico PV Atividade', target: '_blank') { content_tag(:i, nil, class: 'fa fa-plus-square m-r-5') },
        link_to(backoffice_admin_pv_histories_path(username: user.username), title: 'Histórico PVs', target: '_blank') { content_tag(:i, nil, class: 'fa fa-clock-o m-r-5') },
        link_to(edit_backoffice_support_user_path(user), title: 'Editar Usuário', target: '_blank') { content_tag(:i, nil, class: 'fa fa-edit m-r-5') }
      ].join.html_safe
    end
  end
  column(:sign_in, mandatory: true) do |user|
    format(user) do |user|
      if current_user.username == 'sistema'
        link_to(masquerade_path(user), title: 'Logar como Usuário', target: '_blank') { content_tag(:i, nil, class: 'fa fa-user') }
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