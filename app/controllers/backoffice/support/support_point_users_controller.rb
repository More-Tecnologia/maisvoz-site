module Backoffice
  module Support

    class SupportPointUsersController < SupportController

      def create
        @user = User.find(params[:user_id])
        if @user.update_attributes(role_type_code: RoleType.support_point_code)
          flash[:success] = t('.success')
        else
          flash[:error] = @user.errors.full_messages.join(', ')
        end
        redirect_to backoffice_support_user_path(@user)
      end

    end

  end
end
