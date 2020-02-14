module Users
  class EmailsController < BackofficeController

    before_action :ensure_email, only: %i[edit update]

    def index
      @emails = current_user.emails.order(updated_at: :desc)
    end

    def new
      @email = Email.new
    end

    def create
      @email = Email.new(ensured_params)
      if @email.save
        flash[:success] = t('.success')
        Emails::NotifyService.call(@email, params[:locale], type: :confirmation)
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
      if Emails::UpdateService.call(@email, params[:status], params[:locale])
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

  end
end
