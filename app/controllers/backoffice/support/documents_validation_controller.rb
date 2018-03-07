module Backoffice
  module Support
    class DocumentsValidationController < SupportController

      def index
        non_verified_accounts
      end

      def update
        user.update! verified: true
        redirect_back(fallback_location: backoffice_support_documents_validation_index_path)
      end

      private

      def non_verified_accounts
        @non_verified_accounts ||= User.where(verified: false).page(params[:page] || 1)
      end

      def user
        User.find(params[:id])
      end

    end
  end
end
