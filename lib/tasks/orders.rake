namespace :orders do
  task create_orders: :environment do
    ActiveRecord::Base.transaction do
      users_file_path = Rails.root.join('db/seeds/data/users.csv')
      headers = %i[id user_login user_email display_name sponsor_id wallet_amount contadorUdgrade gananciaDoble ganado]

      users = CSV.read(users_file_path, headers: headers).index_by { |u| u[:id] }
      deposit_product = Product.first

      users.each do |id, u|
        begin
          user = User.find_by(username: I18n.transliterate(u[:user_login].to_s.gsub(/\s+/, '').downcase))

          if(u[:gananciaDoble].to_f.positive?)
            total_cents = u[:gananciaDoble].to_f / 2.0
            total_cents += 5 if total_cents > 10
            total_cents *= 100

            order = user.orders.create!(total_cents: total_cents,
                                        status: Order.statuses[:pending_payment])
            order.order_items.create!(product: deposit_product,
                                      quantity: total_cents / 100.0,
                                      unit_price_cents: 1,
                                      total_cents: total_cents)

            response = Financial::PaymentCompensation.call(order, false)
            raise "order not aproved #{response}" unless response.success?

            contract = user.bonus_contracts.first
            ganado = u[:ganado].to_f.negative? ? 0 : u[:ganado].to_f
            remaining_balance = contract.cent_amount - ganado

            if remaining_balance.negative?
              puts "#{u}"
              raise "#{u}"
            end

            contract.update!(received_balance: ganado,
                             remaining_balance: remaining_balance)

            credit = user.financial_transactions.create!(cent_amount: u[:wallet_amount].to_f,
                                                         financial_reason: FinancialReason.credit_reason,
                                                         spreader: User.find_morenwm_customer_admin,
                                                         moneyflow: :credit,
                                                         note: 'System migration')
          end
        rescue StandardError => error
          raise error
        end
      end
    end
  end
end
