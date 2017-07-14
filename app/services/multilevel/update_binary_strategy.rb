module Multilevel
  class UpdateBinaryStrategy

    prepend SimpleCommand

    def initialize(sponsor, params)
      @sponsor = sponsor
      @params = params
    end

    def call
      if form.valid?
        update_binary_strategy
      else
        errors.add(:error, 'some error')
      end
      return form
    end

    private

    attr_reader :sponsor, :params

    def update_binary_strategy
      ActiveRecord::Base.transaction do
        update_sponsor_strategy
        update_binary_positions
      end
    end

    def update_sponsor_strategy
      sponsor.update!(binary_strategy: form.binary_strategy)
    end

    def update_binary_positions
      return if form.binary_positions.blank?
      form.binary_positions.each do |id, position|
        User.find(id).update!(binary_position: position)
      end
    end

    def form
      @form ||= BinaryStrategyForm.new(form_params)
    end

    def form_params
      params[:binary_strategy_form][:sponsor] = sponsor
      params[:binary_strategy_form]
    end

  end
end
