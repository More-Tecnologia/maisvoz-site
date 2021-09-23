class AddEarningsPerCampaignToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :earnings_per_campaign, :decimal, default: 0
  end
end
