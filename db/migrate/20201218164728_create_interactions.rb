class CreateInteractions < ActiveRecord::Migration[5.2]
  def change
    create_table :interactions do |t|
    	t.references :ticket, foreign_key: true
    	t.references :user, foreign_key: true
    	t.text :body
    	t.boolean :active, default: true
    	t.integer :status

    	t.timestamps
    end
  end
end
