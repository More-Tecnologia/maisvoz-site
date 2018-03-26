class AddFiscalDocumentLinkToWithdrawals < ActiveRecord::Migration[5.1]
  def change
    add_column :withdrawals, :fiscal_document_link, :string
  end
end
