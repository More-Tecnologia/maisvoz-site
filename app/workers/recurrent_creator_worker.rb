class RecurrentCreatorWorker
  include Sidekiq::Worker

  def perform(user_id, transaction_id)
    user = User.find(user_id)
    transaction = FinancialTransaction.find(transaction_id)

    Bonification::RecurrentCreatorService.call(user: user,
                                               transaction: transaction)
  end
end
