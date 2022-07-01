# frozen_string_literal: true

module Backoffice
  class RafflesController < BackofficeController
    skip_before_action :authenticate_user!

    def index; end

    def agreement; end

    def winners; end

    def show; end
  end
end
