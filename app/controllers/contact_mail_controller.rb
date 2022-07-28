class ContactMailController < ApplicationController
  def create
    ClientsMailer.sender({ name: params[:name], email: params[:email], subject: params[:subject], message: params[:message] }).deliver_later
    redirect_to root_path
  end
end