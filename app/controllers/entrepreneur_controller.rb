class EntrepreneurController < BackofficeController

  before_action :ensure_admin_or_entrepreneur

  private

  def ensure_admin_or_entrepreneur
    return if signed_in? && (current_user.admin? || current_user.empreendedor?)
    redirect_to root_path
  end

  def should_be_verified
    if !current_user.verified?
      flash[:error] = t('.unverified_account')
      redirect_to edit_backoffice_documents_path
    end
  end

  def ensure_bank_account_valid
    if !current_user.valid?(:withdrawal)
      flash[:error] = t('activerecord.errors.messages.bank_account_presence')
      redirect_to edit_backoffice_bank_account_path
    end
  end

end
