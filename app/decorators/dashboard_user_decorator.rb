class DashboardUserDecorator
  BINARY = FinancialReason.binary_bonus
  BINARY_CHARGEBACK = FinancialReason.binary_bonus
  DIRECT_COMMISSION = FinancialReason.direct_commission_bonus
  DIRECT_COMMISSION_CHARGEBACK = FinancialReason.direct_commission_bonus_chargeback
  MATCHING = FinancialReason.matching_bonus
  MATCHING_CHARGEBACK = FinancialReason.matching_bonus
  POOL_TRADE = FinancialReason.pool_tranding
  POOL_TRADE_CHARGEBACK = FinancialReason.pool_tranding
  RESIDUAL = FinancialReason.residual_bonus
  RESIDUAL_CHARGEBACK = FinancialReason.residual_bonus

  def initialize(user)
    @user = user
    @financial_transactions = FinancialTransaction.by_current_user(@user)
                                                  .to_empreendedor
                                                  .with_active_bonus
    @chargeback = @financial_transactions.debit
    @bonus = @financial_transactions.credit
    @children = @user.unilevel_node.children
    @binary_score = left_binary_score > right_binary_score ? I18n.t(:right) : I18n.t(:left)
  end

  def build
    {
      data: {
        balances: balances,
        bonus: bonus,
        unilevel_counts: unilevel_counts,
        binary_count: binary_count,
        binary_scores: binary_scores
      },
      labels: {
        available_balance: I18n.t(:available_balance),
        balance: I18n.t(:balance),
        binary_affiliates_count: I18n.t(:binary_affiliates_count),
        binary_affiliates_left_count: I18n.t(:binary_affiliates_left_count),
        binary_affiliates_right_count: I18n.t(:binary_affiliates_right_count),
        binary: I18n.t(:binary_bonus),
        binary_scores: I18n.t(:binary_scores),
        blocked_balance: I18n.t(:blocked_balance),
        chargebacks: I18n.t(:chargebacks),
        direct_commission: I18n.t(:direct_commission_bonus),
        left_binary_score: I18n.t(:left_binary_score),
        matching: I18n.t(:matching_bonus),
        pool_trade: I18n.t(:pool_trade_bonus),
        residual: I18n.t(:residual_bonus),
        right_binary_score: I18n.t(:right_binary_score),
        total_bonus: I18n.t(:total_bonus),
        unilevel_affiliates_count: I18n.t(:unilevel_affiliates_count),
        unilevel_affiliates_actives_count: I18n.t(:unilevel_affiliates_actives_count),
        unilevel_affiliates_inactives_count: I18n.t(:unilevel_affiliates_inactives_count)
      }
    }
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
          .sum(&:cent_amount) - @chargeback.by_bonus(BINARY_CHARGEBACK)
                                           .sum(&:cent_amount)
  end

  def binary_count
    {
      binary_affiliates_count: binary_affiliates_count,
      binary_affiliates_left_count: binary_affiliates_left_count,
      binary_affiliates_right_count: binary_affiliates_right_count
    }
  end

  def binary_scores
    {
      binary_score: @binary_score,
      left_binary_score: left_binary_score,
      right_binary_score: right_binary_score
    }
  end

  def blocked_balance
    @user.blocked_balance
  end

  def bonus
    {
      binary: binary_bonus,
      total_bonus: total_bonus,
      direct_commission: direct_commission_bonus,
      matching: matching_bonus,
      pool_trade: pool_trade_bonus,
      residual: residual_bonus,
      chargebacks: @chargeback.sum(&:cent_amount),
      gross_bonus: @bonus.sum(&:cent_amount)
    }
  end

  def direct_commission_bonus
    @bonus.by_bonus(DIRECT_COMMISSION)
          .sum(&:cent_amount) - @chargeback.by_bonus(DIRECT_COMMISSION_CHARGEBACK)
                                           .sum(&:cent_amount)
  end

  def left_binary_score
    @user.binary_node.left_leg_accumulated_score
  end

  def matching_bonus
    @bonus.by_bonus(MATCHING)
          .sum(&:cent_amount) - @chargeback.by_bonus(MATCHING_CHARGEBACK)
                                           .sum(&:cent_amount)
  end

  def pool_trade_bonus
    @bonus.by_bonus(POOL_TRADE)
          .sum(&:cent_amount) - @chargeback.by_bonus(POOL_TRADE_CHARGEBACK)
                                           .sum(&:cent_amount)
  end

  def residual_bonus
    @bonus.by_bonus(RESIDUAL)
          .sum(&:cent_amount) - @chargeback.by_bonus(RESIDUAL_CHARGEBACK)
                                           .sum(&:cent_amount)
  end

  def right_binary_score
    @user.binary_node.right_leg_accumulated_score
  end

  def unilevel_counts
    {
      unilevel_affiliates_count: unilevel_affiliates_count,
      unilevel_affiliates_actives_count: unilevel_affiliates_actives_count,
      unilevel_affiliates_inactives_count: unilevel_affiliates_inactives_count
    }
  end

  def total_bonus
    @bonus.sum(&:cent_amount) - @chargeback.sum(&:cent_amount)
  end

  def unilevel_affiliates_count
    @children.count
  end

  def unilevel_affiliates_actives_count
    @children.includes(:user).where(user: User.active).count
  end

  def unilevel_affiliates_inactives_count
    @children.includes(:user).where(user: User.inactive).count
  end

end
