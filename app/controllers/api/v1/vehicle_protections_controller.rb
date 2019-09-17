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

      def update
        command = Api::UpdaterVehicleProtectionService.call(params_to_update)

        if command.success?
          render(json: { status: 'SUCCESS', data: command.result }, status: :ok)
        else
          render(json: { status: 'ERROR', data: command.errors }, status: :bad_request)
        end
      end

      private

      def params_to_update
        params.require(:inspection).permit(:cnpj_cpf, :plate, :status)
      end
    end
  end
end
