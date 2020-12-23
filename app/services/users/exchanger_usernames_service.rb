module Users
  class ExchangerUsernamesService < ApplicationService
    def call
      ActiveRecord::Base.transaction do
        change_source_username_to_temp_username
        change_destination_username_to_source_username
        change_source_username_to_destination_username
      end
    end

    private

    attr_accessor :source_username, :destination_username, :temp_username,
                  :source_user, :destination_username

    def initialize(args)
      @source_username = args[:source_username]
      @source_user = User.find_by(username: @source_username)
      @destination_username = args[:destination_username]
      @destination_user = User.find_by(username: @destination_username)
      @temp_username = SecureRandom.hex(6)
    end

    def change_source_username_to_temp_username
      source_user.update!(username: temp_username)
      source_user.unilevel_node.update!(username: temp_username)
    end

    def change_destination_username_to_source_username
      destination_user.update!(username: source_username)
      destination_user.unilevel_node.update!(username: source_username)
    end

    def change_source_username_to_destination_username
      source_user.update!(username: destination_username)
      source_user.unilevel_node.update!(username: destination_username)
    end
  end
end
