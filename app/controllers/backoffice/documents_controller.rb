module Backoffice
  class DocumentsController < BackofficeController

    def edit
    end

    def update
      if params.key?(:user) && current_user.update(documents_params)
        flash[:success] = 'Documentos atualizados com sucesso'
        redirect_to backoffice_documents_path
      else
        flash[:notice] = 'Não foi possível fazer o upload dos documentos'
        render :edit
      end
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
