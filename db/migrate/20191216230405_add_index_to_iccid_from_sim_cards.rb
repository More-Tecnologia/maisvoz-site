class AddIndexToIccidFromSimCards < ActiveRecord::Migration[5.2]
  def change
    add_index :sim_cards, :iccid
  end
end
