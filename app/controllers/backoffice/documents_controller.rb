module Backoffice
  class DocumentsController < EntrepreneurController

    def edit
    end

    def update
      if params.key?(:user) && current_user.update!(documents_params)
        current_user.update!(document_verification_status: 'pending_verification', document_verification_updated_at: Time.now)
        flash.now[:success] = t(:documents_successful_updated)
      else
        flash.now[:notice] = t(:documents_not_updated)
      end
      render :edit
    end

    private

    def documents_params
      params.require(:user).permit(
        :document_rg_photo,
        :document_pis_photo,
        :document_cpf_photo,
        :document_address_photo,
        :document_scontract_photo
      )
    end

    def ensure_admin_or_entrepreneur
      return if signed_in? && (current_user.admin? || current_user.empreendedor? || current_user.instalador?)
      flash[:error] = t(:admin_or_entrepreneur_necessary)
      redirect_to root_path
    end

  end
end
