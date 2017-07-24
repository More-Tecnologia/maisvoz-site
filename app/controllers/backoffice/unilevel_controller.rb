module Backoffice
  class UnilevelController < BackofficeController

    def index
      render(:index, locals: { unilevel: unilevel, max_generation: max_generation })
    end

    private

    def unilevel
      @unilevel ||= Multilevel::FetchUnilevel.call(current_user).result
    end

    def max_generation
      @max_generation ||= unilevel.map { |d| d[:generations].size }.max || 0
    end

  end
end
