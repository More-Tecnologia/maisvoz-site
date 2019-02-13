module Backoffice
  module Support
    class DocumentsValidationController < SupportController

      def index
        non_verified_accounts
      end

      def update
        if params[:status] == 'verified'
          user.update!(document_verification_status: 'verified', document_verification_updated_at: Time.now)
        elsif params[:delete].present? && params[:status] == User.document_verification_statuses['refused_verification']
          ActiveRecord::Base.transaction do
            user.update!(document_refused_reason: params[:reason], document_verification_updated_at: Time.now)
            user.refused_verification!
            user.destroy_documents!
          end
        elsif params[:status] == User.document_verification_statuses['refused_verification']
          ActiveRecord::Base.transaction do
            user.update!(document_refused_reason: params[:reason], document_verification_updated_at: Time.now)
            user.refused_verification!
          end
        end
        redirect_back(fallback_location: backoffice_support_documents_validation_index_path)
      end

      private

      def non_verified_accounts
        if params[:document_verification_status].blank?
          @non_verified_accounts ||= User.all.page(params[:page] || 1)
        else
          @non_verified_accounts ||= User.where(document_verification_status: params[:document_verification_status]).page(params[:page] || 1)
        end
      end

      def user
        User.find(params[:id])
      end

    end
  end
end
