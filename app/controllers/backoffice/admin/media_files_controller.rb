# frozen_string_literal: true

module Backoffice
  module Admin
    class MediaFilesController < AdminController
      before_action :ensure_creation, only: :create
      before_action :ensure_media_file, except: %i[new create]

      def show; end

      def new
        @media_file = MediaFile.new
      end

      def create
        flash[:success] = t('.success') # 'Arquivo anexado com sucesso'
        redirect_to [:backoffice, :admin, @media_file]
      end

      def edit; end

      def update
        if @media_file.update(ensured_params)
          flash[:success] = t('.success') # 'Arquivo atualizado com sucesso'
          redirect_to [:backoffice, :admin, @media_file]
        else
          flash[:error] = @media_file.errors.full_messages.join(', ')
          render :edit
        end
      end

      private

      def ensure_creation
        # this step is necessary because of attachinary gem bug -
        # https://github.com/assembler/attachinary/issues/130
        # Remove this gem in favor of active storage
        new_params = ensured_params
        file = new_params.delete(:file_content)

        @media_file = MediaFile.new(new_params)
        @media_file.save
        return if @media_file.persisted? && @media_file.update(file_content: file)

        flash[:error] = @media_file.errors.full_messages.join(', ')
        @media_file.destroy
        render :new
      end

      def ensured_params
        params.require(:media_file).permit(:file_content, :active, :title)
      end

      def ensure_media_file
        @media_file = MediaFile.find(params[:id].to_i)
      end

    end
  end
end
