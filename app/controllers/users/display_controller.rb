# frozen_string_literal: true

module Users
  class DisplayController < BackofficeController

    def index; end

    def edit_login; end

    def edit_password; end

    def update_login
      params[:user][:username] = params[:user][:username].gsub(/[ +]/, '')
      if current_user.update_with_password(user_params(%i[username
                                                          country
                                                          current_password]))
        redirect_to users_display_index_path
      else
        render 'edit_login'
      end
    end

    def update_password
      if current_user.update_with_password(user_params(%i[password
                                                          password_confirmation
                                                          current_password]))
        bypass_sign_in(current_user)
        flash[:success] = t(:password_updated_successfully)
        redirect_to users_display_index_path
      else
        flash[:error] = current_user.errors.full_messages.join(', ')
        render 'edit_password'
      end
    end

    def update_profile
      params[:user][:username] = params[:user][:username].gsub(/[ +]/, '')
      if current_user.update_with_password(user_params(%i[name avatar country username current_password]))
        flash[:success] = t(:profile_updated_successfully)
        redirect_to users_display_index_path
      else
        flash[:error] = current_user.errors.full_messages.join(', ')
        render 'users/registrations/edit'
      end
    end

    private

    def user_params(attributes)
      params.require(:user).permit(attributes)
    end

  end
end
