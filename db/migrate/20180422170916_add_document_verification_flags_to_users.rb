class AddDocumentVerificationFlagsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :document_refused_reason, :string
    add_column :users, :document_verification_status, :string
    add_index :users, :document_verification_status
  end
end
