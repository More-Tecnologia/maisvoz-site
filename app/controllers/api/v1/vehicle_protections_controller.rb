module Api
  module V1
    class VehicleProtectionsController < ApiController

      def create
        command = Api::CreateVehicleProtection.call(params)

        if command.success?
          render(json: { status: 'SUCCESS', data: command.result }, status: :ok)
        else
          render(json: { status: 'ERROR', data: command.errors }, status: :bad_request)
        end
      end

    end
  end
end
