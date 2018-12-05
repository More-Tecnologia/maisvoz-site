module Api
  module V1
    class UsersController < ApiController

      def sign_in
        if signin_form.valid? && signin_form.verified?
          render(json: { status: 'SUCCESS', data: signin_form.user_serialized }, status: :ok)
        else
          render(json: { status: 'ERROR', data: signin_form.errors }, status: :bad_request)
        end
      end

      def find_by_cpf
        form = Api::FindByCpfForm.new(params)
        if form.valid?
          render(json: { status: 'SUCCESS', data: form.user_serialized }, status: :ok)
        else
          render(json: { status: 'ERROR', data: form.errors }, status: :bad_request)
        end
      end

      private

      def signin_form
        @signin_form ||= Api::SigninForm.new(params)
      end

    end
  end
end
