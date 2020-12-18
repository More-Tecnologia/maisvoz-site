class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
    	t.references :subject, foreign_key: true
    	t.references :user, foreign_key: true
    	t.references :attendant_user, foreign_key: { to_table: 'users' }
    	t.string :title
    	t.text :body
    	t.integer :status, index: true, default: 0
    	t.boolean :active, default: false
    	t.datetime :finished_at

    	t.timestamps
    end
  end
end