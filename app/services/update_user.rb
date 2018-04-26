class UpdateUser

  def initialize(form, user)
    @form = form
    @user = user
  end

  def call
    return false unless form.valid?
    ActiveRecord::Base.transaction do
      update_user
    end
    true
  end

  private

  attr_reader :form, :user

  def update_user
    user.update!(form_attributes)
  end

  def form_attributes
    attrs = form.attributes
    if form.password.blank? && form.password_confirmation.blank?
      attrs.delete(:password)
      attrs.delete(:password_confirmation)
    end
    attrs.except(:user_id)
  end

end
