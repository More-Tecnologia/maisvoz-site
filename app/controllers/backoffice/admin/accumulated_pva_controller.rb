module Backoffice
  module Admin
    class AccumulatedPvaController < AdminController

      def index
        render(:index, locals: { sponsored: sponsored, user: user })
      end

      private

      def user
        if params[:username].present?
          User.find_by(username: params[:username]).decorate
        else
          User.first.decorate
        end
      end

      def sponsored
        @sponsored ||= user.sponsored.order(pva_total: :desc).decorate
      end

    end
  end
end
