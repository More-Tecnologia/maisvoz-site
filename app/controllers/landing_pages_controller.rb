class LandingPagesController < ApplicationController

  before_action :ensure_signed_out
  before_action :ensure_sponsor

  layout 'public'

  def index; end

  def ensure_signed_out
    redirect_to backoffice_products_path if user_signed_in?
  end

  def ensure_sponsor
    if params[:sponsor].present?
      @sponsor = User.find_by(username: params[:sponsor])
    end
  end

end
