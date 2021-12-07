# frozen_string_literal: true

module Backoffice
  class DirectNomineesListController < BackofficeController
    def index
      @nominees = User.where(sponsor: current_user)
                      .page(params[:page])
                      .per(10)
    end
  end
end
