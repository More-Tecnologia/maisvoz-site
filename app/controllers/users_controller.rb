# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :sanitaze_username

  def create
    user = User.new(valid_params)
    if user.save
      sign_in(user)
      @user = user
    else
      @error = user.errors.full_messages.join(', ')
    end
  end

  private

  def sanitaze_username
    params[:user][:username] = I18n.transliterate(params[:user][:username].to_s.gsub(/\D+/, '').downcase)
  end

  def valid_params
    params.require(:user)
          .permit(:country, :email, :username, :password, :password_confirmation)
          .merge(sponsor: User.find_morenwm_customer_user)
  end
end
