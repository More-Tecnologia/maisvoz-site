module Api
  class CreateUser

    def initialize(form)
      @form = form
    end

    def call
      @user = User.new.tap do |user|
        user.sponsor           = form.sponsor
        user.username          = form.username
        user.name              = form.name
        user.email             = form.email
        user.document_cpf      = form.cpf
        user.password          = form.password
        user.registration_type = 'pf'

        user.save!
      end
    end

    private

    attr_reader :form

  end
end
