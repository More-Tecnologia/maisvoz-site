module Backoffice
  module Admin
    class CareerHistoriesController < AdminController

      def index
        render(:index, locals: { career_histories: career_histories })
      end

      private

      def career_histories
        CareerHistoriesQuery.new.call(params)
      end

    end
  end
end
