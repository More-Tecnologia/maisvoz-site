class AddDefaultDocumentVerificationStatusToUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :document_verification_status, :string, default: 'pending_verification'
  end
end
