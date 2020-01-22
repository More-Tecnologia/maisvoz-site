module Backoffice
  module Support

    class SupportPointUsersController < SupportController

      def create
        user = User.find(params[:user_id])
        if user.update_attributes(role_type_code: RoleType.support_point_code)
          associate_consultants_to(user)
          flash[:success] = t('.success')
        else
          flash[:error] = user.errors.full_messages.join(', ')
        end
        redirect_to backoffice_support_user_path(user)
      end

      private

      def associate_consultants_to(user)
        User.without_support_point
            .by_location(user.city, user.state)
            .update_all(support_point_user_id: user.id)
      end

    end

  end
end
