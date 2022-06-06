class MasqueradesController < Devise::MasqueradesController
  protected

  def after_masquerade_path_for(resource)
    raffles_backoffice_stores_path
  end

  def after_back_masquerade_path_for(resource)
    backoffice_support_users_path
  end

end
