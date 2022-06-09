# frozen_string_literal: true

class UsersController < ApplicationController
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

  def valid_params
    params.require(:user)
          .permit(:country, :email, :username, :password, :password_confirmation)
          .merge(sponsor: User.find_morenwm_customer_user)
  end
end
