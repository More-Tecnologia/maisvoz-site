class DashboardUserDecorator
  POOL_TRADE = FinancialReason.pool_tranding
  BINARY = FinancialReason.binary_bonus
  RESIDUAL = FinancialReason.residual_bonus
  MATCHING = FinancialReason.matching_bonus

  def initialize(user)
    @user = user
    @bonus_contracts = @user.bonus_contracts.active
    @financial_transactions = FinancialTransaction.by_current_user(@user)
                                                  .to_empreendedor
                                                  .with_active_bonus
    @chargeback = @financial_transactions.debit
    @bonus = @financial_transactions.credit
    @children = @user.unilevel_node.children
  end

  def build
    {
      data: {
        earnings: earnings,
        balances: balances,
        bonus: bonus,
        unilevel_counts: unilevel_counts,
        binary_count: binary_count
      },
      labels: {
        balance: I18n.t(:balance),
        available_balance: I18n.t(:available_balance),
        blocked_balance: I18n.t(:blocked_balance),
        binary_affiliates_count: I18n.t(:binary_affiliates_count),
        binary_affiliates_left_count: I18n.t(:binary_affiliates_left_count),
        binary_affiliates_right_count: I18n.t(:binary_affiliates_right_count),
        binary_bonus: I18n.t(:binary_bonus),
        bonus_total: I18n.t(:bonus_total),
        matching_bonus: I18n.t(:matching_bonus),
        pool_trade_bonus: I18n.t(:pool_trade_bonus),
        residual_bonus: I18n.t(:residual_bonus),
        account_earnings_limit: I18n.t(:account_earnings_limit),
        receivable_amount: I18n.t(:receivable_amount),
        received_amount: I18n.t(:received_amount),
        unilevel_affiliates_count: I18n.t(:unilevel_affiliates_count),
        unilevel_affiliates_left_count: I18n.t(:unilevel_affiliates_left_count),
        unilevel_affiliates_right_count: I18n.t(:unilevel_affiliates_right_count)
      }
    }
  end

  def account_earnings_limit
    @bonus_contracts.sum(&:cent_amount)
  end

  def available_balance
    @user.available_balance
  end

  def balance
    available_balance + blocked_balance
  end

  def balances
    {
      balance: balance,
      available_balance: available_balance,
      blocked_balance: blocked_balance
    }
  end

  def binary_count
    {
      binary_affiliates_count: binary_affiliates_count,
      binary_affiliates_left_count: binary_affiliates_left_count,
      binary_affiliates_right_count: binary_affiliates_right_count
    }
  end

  def binary_affiliates_count
    @user.binary_node.descendants.count
  end

  def binary_affiliates_left_count
    return 0 unless @user.binary_node.left_child.present?

    @user.binary_node.left_child.descendants.count + 1
  end

  def binary_affiliates_right_count
    return 0 unless @user.binary_node.right_child.present?

    @user.binary_node.right_child.descendants.count + 1
  end

  def binary_bonus
    @bonus.by_bonus(BINARY)
          .sum(&:cent_amount) - @chargeback.by_bonus(BINARY)
                                           .sum(&:cent_amount)
  end

  def blocked_balance
    @user.blocked_balance
  end

  def bonus
    {
      binary_bonus: binary_bonus,
      bonus_total: bonus_total,
      matching_bonus: matching_bonus,
      pool_trade_bonus: pool_trade_bonus,
      residual_bonus: residual_bonus
    }
  end

  def bonus_total
    @bonus.sum(&:cent_amount) - @chargeback.sum(&:cent_amount)
  end

  def earnings
    {
      account_earnings_limit: account_earnings_limit,
      receivable_amount: receivable_amount,
      received_amount: received_amount
    }
  end

  def matching_bonus
    @bonus.by_bonus(MATCHING)
          .sum(&:cent_amount) - @chargeback.by_bonus(MATCHING)
                                           .sum(&:cent_amount)
  end

  def pool_trade_bonus
    @bonus.by_bonus(POOL_TRADE)
          .sum(&:cent_amount) - @chargeback.by_bonus(POOL_TRADE)
                                           .sum(&:cent_amount)
  end

  def receivable_amount
    @bonus_contracts.sum(&:remaining_balance)
  end

  def received_amount
    @bonus_contracts.sum(&:received_balance)
  end

  def residual_bonus
    @bonus.by_bonus(RESIDUAL)
          .sum(&:cent_amount) - @chargeback.by_bonus(RESIDUAL)
                                           .sum(&:cent_amount)
  end

  def unilevel_counts
    {
      unilevel_affiliates_count: unilevel_affiliates_count,
      unilevel_affiliates_left_count: unilevel_affiliates_left_count,
      unilevel_affiliates_right_count: unilevel_affiliates_right_count
    }
  end

  def unilevel_affiliates_count
    @children.count
  end

  def unilevel_affiliates_left_count
    @children.includes(:user).where(users: { binary_position: :left }).count
  end

  def unilevel_affiliates_right_count
    @children.includes(:user).where(users: { binary_position: :right }).count
  end

end
