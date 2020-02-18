module Users
  class EmailsController < BackofficeController
    before_action :ensure_email, only: %i[edit update]
    before_action :same_email_verification, only: :create
    before_action :ensure_status, only: :create

    def index
      @emails = current_user.emails.order(updated_at: :desc)
    end

    def new
      @email = Email.new
    end

    def create
      if ensure_email_existence
        flash[:success] = t('.success')
        redirect_to root_path
      else
        flash[:error] = @email.errors.full_messages.join(', ')
        render :new
      end
    end

    def edit
      return if @email.status.to_sym == :pending && params[:path] == 'email'

      flash[:success] = t('.unauthorized_action')
      redirect_to users_emails_path
    end

    def update
      if update_email
        flash[:success] = t('.success')
        redirect_to users_emails_path
      else
        flash[:error] = @email.errors.full_messages.join(', ')
        render :edit
      end
    end

    private

    def ensured_params
      params.require(:email)
            .permit(:body)
            .merge(user: current_user)
    end

    def ensure_email
      @email = Email.find_by_hashid(params[:id])
    end

    def ensure_email_existence
      @email = current_user.emails.where(body: params[:email][:body]).first || Email.new(ensured_params)


      @email.persisted? ? update_email : create_email
    end

    def ensure_status
      params[:email].merge!(status: :pending)
    end

    def create_email
      Emails::CreateService.call(@email, params[:locale])
    end

    def update_email
      Emails::UpdateService.call(@email, params[:email][:status], params[:locale])
    end

    def same_email_verification
      return unless params[:email][:body] == current_user.email

      flash[:error] = t('.same_email', email: params[:email][:body])
      redirect_to new_users_email_path
    end
  end
end
