class LandingPagesController < ApplicationController

  before_action :ensure_signed_out
  before_action :ensure_sponsor
  before_action :last_users, only: :index

  layout 'public'

  def index; end

  private

  def ensure_signed_out
    redirect_to backoffice_dashboard_index_path if user_signed_in?
  end

  def ensure_sponsor
    return unless params[:sponsor].present?

    @sponsor = User.find_by(username: params[:sponsor])
  end

  def last_users
    @users = User.order(created_at: :desc).last(10)
  end

end
