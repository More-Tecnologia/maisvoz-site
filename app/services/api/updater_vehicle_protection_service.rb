module Api
  class UpdaterVehicleProtectionService < ApiController
    prepend SimpleCommand
    include ActiveModel::Validations

    def initialize(params)
      @params = params
    end

    def call
      subscription = find_subscription
      return nil unless subscription

      if subscription.update_attributes(params)
        return serialize(subscription)
      else
        errors.add(:base, subscription.errors.full_messages.to_sentence)
      end
    end

    private

    attr_reader :params

    def find_subscription
      club_motors_subscription =
        ClubMotorsSubscription.ancore.find_by(params.slice([:cnpj_cpf, :plate]))
      errors.add(:base, 'not found') unless club_motors_subscription
      club_motors_subscription
    end

    def serialize(club_motors_subscription)
      ClubMotorsSubscriptionSerializer.new(club_motors_subscription).serialize
    end
  end
end
