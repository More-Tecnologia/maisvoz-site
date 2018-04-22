module Backoffice
  class DocumentsController < EntrepreneurController

    def edit
    end

    def update
      if params.key?(:user) && current_user.update!(documents_params)
        current_user.pending_verification!
        flash[:success] = 'Documentos atualizados com sucesso'
      else
        flash[:notice] = 'Não foi possível fazer o upload dos documentos'
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

  end
end
