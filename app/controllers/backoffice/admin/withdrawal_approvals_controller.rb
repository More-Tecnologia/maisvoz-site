module Backoffice::Admin
  class WithdrawalApprovalsController < AdminController
    include Backoffice::WithdrawalApprovalsHelper

    before_action :find_withdrawals, only: %i[new create]
    before_action :validate_master_password, only: :create

    def new; end

    def create
      approve_and_transfer_withdrawals_amount(@withdrawals)
      flash[:success] = t('.success')
      redirect_to backoffice_admin_withdrawals_path
    end

    rescue_from 'StandardError' do |error|
      flash[:error] = error.message
      redirect_back(fallback_location: root_path)
    end

    private

    def find_withdrawals
      @withdrawals ||= Withdrawal.includes(:user)
                                 .pending
                                 .where(id: params[:ids].split(','))
    end

    def validate_master_password
      return if authenticate_master_password?(params[:master_password])

      flash[:error] = t('defaults.unauthenticate_master_password')
      redirect_back(fallback_location: root_path)
    end
  end
end
