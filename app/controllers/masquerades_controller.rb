class MasqueradesController < Devise::MasqueradesController
  protected

  def after_masquerade_path_for(resource)
    backoffice_dashboard_index_path(locale: 'pt-BR')
  end

end
