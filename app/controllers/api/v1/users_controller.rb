module Api
  module V1
    class UsersController < ApiController

      def sign_in
        if signin_form.valid? && signin_form.verified?
          render(json: { status: 'SUCCESS', data: signin_form.attributes }, status: :ok)
        else
          render(json: { status: 'ERROR', data: signin_form.errors }, status: :bad_request)
        end
      end

      def sign_up
        if signup_form.valid? && user = Api::CreateUser.new(signup_form).call
          render(json: { status: 'SUCCESS', data: UserSerializer.new(user).serialize }, status: :ok)
        else
          render(json: { status: 'ERROR', data: signup_form.errors.to_h.map {|k,v| "#{k}: #{v}"}.join(', ') }, status: :bad_request)
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

      def remember_password
        if User.exists?(email: params[:email]) &&
           User.find_by(email: params[:email]).send_reset_password_instructions
          render(json: { status: 'SUCCESS' }, status: :ok)
        else
          render(json: { status: 'ERROR' }, status: :bad_request)
        end
      end

      private

      def signin_form
        @signin_form ||= Api::SigninForm.new(params)
      end

      def signup_form
        @signup_form ||= Api::SignupForm.new(params)
      end

    end
  end
end
