module Backoffice
  module Admin
    class UsersController < AdminController

      def index
        render(:index, locals: { users: users })
      end

      def show
        render(:show, locals: { user: user })
      end

      private

      def users
        User.order(id: :desc).page(params[:page])
      end

      def user
        UserDecorator.new(User.find(params[:id]))
      end

    end
  end
end
