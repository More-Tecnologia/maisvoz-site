class AddDocumentRgExpeditorToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :document_rg_expeditor, :string
  end
end
