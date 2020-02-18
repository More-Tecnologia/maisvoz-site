class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.string :body
      t.integer :status, default: 0
      t.references :user

      t.timestamps
    end
  end
end
