# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    user = User.find_for_authentication(username: params[:user][:login])
    password = params[:user][:password]
    if user&.valid_password?(password) 
      sign_in(user)
      @user = user
    else
      @error = t(:wrong_user_or_password)
    end
  end
end