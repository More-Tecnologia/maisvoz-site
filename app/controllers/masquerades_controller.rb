class MasqueradesController < Devise::MasqueradesController
  protected

  def after_masquerade_path_for(resource)
    if SystemConfiguration.whitelabel?
     raffles_backoffice_stores_path
    else
      backoffice_products_path
    end
  end

  def after_back_masquerade_path_for(resource)
    backoffice_support_users_path
  end
end
