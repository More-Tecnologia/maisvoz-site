# frozen_string_literal: true

module Users
  class DisplayController < BackofficeController

    def index; end

    def edit_login; end

    def edit_password; end

    def update_login
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
        # Sign in the user by passing validation in case their password changed
        bypass_sign_in(current_user)
        redirect_to users_display_index_path
      else
        render 'edit_password'
      end
    end

    def update_profile
      if current_user.update(user_params(%i[name avatar]))
        redirect_to users_display_index_path
      else
        render 'edit'
      end
    end

    private

    def user_params(attributes)
      params.require(:user).permit(attributes)
    end

  end
end
