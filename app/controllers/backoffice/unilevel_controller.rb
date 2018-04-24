module Backoffice
  class UnilevelController < EntrepreneurController

    def index
      render :index
    end

    private

    def unilevel
      @unilevel ||= Multilevel::FetchUnilevel.call(current_user).result
    end

    def max_generation
      return 0 if unilevel.blank?
      @max_generation ||= unilevel.map { |d| d[:generations].size }.max
    end

  end
end
