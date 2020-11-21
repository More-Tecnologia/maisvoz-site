module Backoffice
  module WithdrawalApprovalsHelper
    def approve_and_transfer_withdrawals_amount(withdrawals)
      ActiveRecord::Base.transaction do
        approve_withdrawals(withdrawals)
        #transfer_withdrawal_net_amout(withdrawals)
      end
    end

    def current_digital_currency_quote
      @quote ||= current_digital_currency_quote_request
    end

    def current_digital_currency_quote_request
      currency_pair = [ENV['CURRENT_DIGITAL_CURRENCY'], ENV['CURRENT_CURRENCY']].join('-')

      response = HTTParty.get("https://api.coinbase.com/v2/prices/#{currency_pair}/spot")
      response.parsed_response.dig('data', 'amount')
    end

    def current_digital_currency(amount)
      amount.to_f / current_digital_currency_quote.to_f
    end

    private

    def approve_withdrawals(withdrawals)
      withdrawals.each do |w|
        Financial::UpdaterWithdrawalStatusService.call({ updater_user: current_user,
                                                         status: :approved,
                                                         withdrawal: w },
                                                         params[:locale])
      end
    end

    def transfer_withdrawal_net_amout(withdrawals)
      recipients = withdrawals.group_by { |w| w.user.wallet_address }
                              .transform_values { |ws| blockchain_format(ws.sum(&:net_amount_cents)) }

      Webhooks::Blockchain::BulkTransferService.call(recipients: recipients,
                                                     guid: params[:access_key],
                                                     main_password: params[:main_password],
                                                     second_password: params[:second_password])
    end

    def blockchain_format(amount)
      (current_digital_currency(amount) * 1e8).to_i
    end
  end
end
