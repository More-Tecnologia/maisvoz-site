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
        User.order(id: :desc).page(params[:page]).decorate
      end

      def user
        User.find(params[:id]).decorate
      end

    end
  end
end
