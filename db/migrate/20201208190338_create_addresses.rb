class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :country, default: ''
      t.string :city, default: ''
      t.string :state, default: ''
      t.string :neighborhood, default: ''
      t.string :zipcode, default: ''
      t.string :street, default: ''
      t.string :number, default: ''
      t.string :complement, default: ''
      t.string :whatsapp, default: ''
      t.references :order

      t.timestamps
    end
  end
end
