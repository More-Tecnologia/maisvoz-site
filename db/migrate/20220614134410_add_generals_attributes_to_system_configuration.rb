# frozen_string_literal: true

class AddGeneralsAttributesToSystemConfiguration < ActiveRecord::Migration[5.2]
  def change
    add_column :system_configurations, :authorization_key, :string, default: ''
    add_column :system_configurations, :cloudinary_url, :string, default: ''
    add_column :system_configurations, :company_domain_site, :string, default: ''
    add_column :system_configurations, :contact_email, :string, default: ''
    add_column :system_configurations, :current_currency, :string, default: 'BRL'
    add_column :system_configurations, :current_digital_currency, :string, default: 'BTC'
    add_column :system_configurations, :financial_email, :string, default: ''
    add_column :system_configurations, :gateway_wallet_url, :string, default: ''
    add_column :system_configurations, :pagstar_access_key, :string, default: ''
    add_column :system_configurations, :pagstar_api_url, :string, default: ''
    add_column :system_configurations, :pagstar_callback, :string, default: ''
    add_column :system_configurations, :pagstar_login, :string, default: ''
    add_column :system_configurations, :pagstar_tenant_id, :string, default: ''
    add_column :system_configurations, :payment_block_authorization_key, :string, default: ''
    add_column :system_configurations, :payment_block_checkout_url, :string, default: ''
    add_column :system_configurations, :max_ticket_per_order, :integer, default: 10
    add_column :system_configurations, :morenwm_customer_admin, :string, default: ''
    add_column :system_configurations, :morenwm_customer_username, :string, default: ''
    add_column :system_configurations, :morenwm_username, :string, default: ''
    add_column :system_configurations, :sender_email, :string, default: ''
    add_column :system_configurations, :uptime, :boolean, default: true
    add_column :system_configurations, :withdraw_minimum_value, :integer, default: 10
  end
end
