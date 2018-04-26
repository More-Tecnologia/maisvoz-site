class MasqueradesController < Devise::MasqueradesController
  protected

  def after_masquerade_path_for(resource)
    backoffice_dashboard_index_path(locale: 'pt-BR')
  end

  def after_back_masquerade_path_for(resource)
    backoffice_support_users_path(locale: 'pt-BR')
  end

end
