module Backoffice
  module Admin
    class SocialLeaderDebuggerController < AdminController

      def index
        render(:index, locals: { generations: generations })
      end

      private

      def generations
        @generations ||= Multilevel::FetchUnilevelLeaderGenerations.new(user).call
      end

      def user
        params[:username].present? ? User.find_by(username: params[:username]) : current_user
      end

    end
  end
end
