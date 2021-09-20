# frozen_string_literal: true

module Users
  class DisplayController < BackofficeController

    def index; end

    def edit; end

    def update_profile
      if current_user.update(user_params)
        redirect_to users_display_index_path
      else
        render 'edit'
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :avatar)
    end

  end
end
