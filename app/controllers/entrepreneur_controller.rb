class EntrepreneurController < BackofficeController

  # before_action :ensure_admin_or_entrepreneur

  private

  def ensure_admin_or_entrepreneur
    return if signed_in? && (current_user.admin? || current_user.empreendedor? || current_user.financeiro? || current_user.suporte?)
    redirect_to new_backoffice_deposit_path
  end

  def should_be_verified
    if !current_user.verified?
      flash[:error] = t('.unverified_account')
      redirect_to edit_backoffice_documents_path
    end
  end

  def ensure_bank_account_valid
    if ENV['WITHDRAWAL_WITH_DIGITAL_COIN'] == 'true'
      deny_withdrawal unless current_user.valid?(:withdrawal_with_digital_coin)
    else
      deny_withdrawal unless current_user.valid?(:withdrawal)
    end
  end

  def deny_withdrawal
    flash[:error] = t('activerecord.errors.messages.bank_account_presence')
    redirect_to edit_backoffice_bank_account_path
  end

end
