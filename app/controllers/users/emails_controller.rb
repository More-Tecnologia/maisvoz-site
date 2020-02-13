module Users
  class EmailsController < BackofficeController

    before_action :ensure_email, only: %i[edit update]

    def index
      @emails = current_user.emails
    end

    def new
      @email = Email.new
    end

    def create
      @email = Email.new(ensured_params)
      if @email.save
        flash[:success] = t('.success')
        notify_user_email_confirmation
        redirect_to root_path
      else
        flash[:error] = @email.errors.full_messages.join(', ')
        render :new
      end
    end

    def edit; end

    def update
      if @email.update(status: params[:status])
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

    def notify_user_email_confirmation
      EmailsMailer.with(email: @email, locale: @locale)
                  .confirmation
                  .deliver_later
    end

    def notify_user_email_changed
      EmailsMailer.with(email: @email, locale: @locale)
                  .changed
                  .deliver_later
    end

  end
end
