module Backoffice
  module Support
    class BlockedUsersController < SupportController

      def update
        @user = User.update(params[:id], valid_params)
        respond_to do |format|
          format.js
        end
      end

      private

      def valid_params
        params.slice(:blocked)
      end

    end
  end
end
