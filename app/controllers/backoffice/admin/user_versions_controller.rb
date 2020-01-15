module Backoffice
  module Admin
    class UserVersionsController < AdminController

      def index
        @q = User.ransack(params[:q])
        user = @q.result.first
        versions = user.try(:includes, :item).try(:versions)
        @user_versions = versions.try(:any?) ? active_changed_versions : [user]
      end

      private

      def active_changed_versions
        versions.select { |v| v.reify.active_changed? || v.reify.active_until_changed? }
      end

    end
  end
end
