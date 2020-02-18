module Backoffice
  module Support
    class UsersController < SupportController
      before_action :validate_password, only: :update

      def index
        @grid = UsersGrid.new(params.fetch(:users_grid, {}).permit!)

        respond_to do |format|
          format.html { render_index }
          format.csv { render_csv }
        end
      end

      def show
        render(:show, locals: { user: user })
      end

      def edit
        render_edit
      end

      def update
        @user = User.find(params[:id])
        if UpdateUser.new(user_form, @user).call
          redirect_to backoffice_support_user_path(@user)
        else
          flash[:error] = @user.errors.full_messages.join(', ')
          render_edit
        end
      end

      private

      def render_edit
        render :edit, locals: { user_form: user_form, user: user }
      end

      def user
        User.find(params[:id]).decorate
      end

      def user_form
        @user_form ||= UserForm.new(user_params)
      end

      def user_params
        params[:user_form] ||= user.attributes
        params[:user_form][:user_id] ||= user.id
        params[:user_form]
      end

      def render_index
        @grid.scope {|scope| scope.page(params[:page]) }
      end

      def render_csv
        send_data @grid.to_csv,
          type: "text/csv",
          disposition: 'inline',
          filename: "users-#{Time.now.to_s}.csv"
      end

      def validate_password
        return if current_user.valid_password?(params[:current_password])
        flash[:error] = t('invalid_password')
        redirect_to [:edit, :backoffice, :support, :user]
      end
    end
  end
end
