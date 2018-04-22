class AddDocumentVerificationUpdatedAtToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :document_verification_updated_at, :datetime
  end
end
