# frozen_string_literal: true

class RegisterController < ApplicationController
  before_action :sanitaze_username

  def create
    user = User.new(valid_params)
    if user.save
      sign_in(user)
      @user = user
      @products = Product.where(kind: [:deposit, :free]).active.order(:price_cents)
    else
      @error = user.errors.full_messages.join("  <br> ").html_safe
    end
  end

  private

  def sanitaze_username
    params[:user][:username] = I18n.transliterate(params[:user][:username].to_s.gsub(/\D+/, '').downcase)
  end

  def valid_params
    unless cookies[:token].present?
      cookies[:token] = { value: params[:token], expires: Time.now + 15.days }
    end
    sponsor = if cookies[:token].present?
                User.find_by(token: cookies[:token])
              else
                User.find_morenwm_customer_user
              end
    params.require(:user)
          .permit(:country, :email, :username, :password, :password_confirmation)
          .merge(sponsor: sponsor)
  end
end
