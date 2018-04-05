module Backoffice
  class BinaryStrategiesController < EntrepreneurController

    def index
      render(:index, locals: { form: form })
    end

    def create
      command = Multilevel::UpdateBinaryStrategy.call(current_user, params)

      if command.success?
        flash[:success] = I18n.t('defaults.success')
      else
        flash[:error] = command.result.errors.values.join(',')
      end

      redirect_to backoffice_binary_strategies_path
    end

    private

    def form
      @form ||= BinaryStrategyForm.new(
        sponsor: current_user,
        binary_strategy: current_user.binary_strategy
      )
    end

  end
end
