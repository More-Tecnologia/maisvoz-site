module Api
  class CreateUser

    def initialize(form)
      @form = form
    end

    def call
      @user = User.new.tap do |user|
        user.registration_type     = form.registration_type
        user.sponsor               = form.sponsor
        user.username              = form.username
        user.name                  = form.name if user.pf?
        user.email                 = form.email
        user.document_cpf          = form.cpf
        user.document_cnpj         = form.cnpj
        user.password              = form.password
        user.document_company_name = form.name if user.pj?

        user.save!
      end
    end

    private

    attr_reader :form

  end
end
