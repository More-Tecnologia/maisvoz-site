class MasqueradesController < Devise::MasqueradesController
  protected

  def after_masquerade_path_for(resource)
    backoffice_admin_users_path
  end

end
