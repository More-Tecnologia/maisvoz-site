class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :masquerade_user!

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || backoffice_dashboard_index_path
  end
end
