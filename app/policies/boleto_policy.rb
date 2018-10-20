class BoletoPolicy

  ATTRS = %w[name address district city state].freeze

  def initialize(user:)
    @user = user
  end

  def can_generate?
    ATTRS.all? { |attr| user.send(attr).present? } &&
      valid_document?
  end

  private

  attr_reader :user

  def valid_document?
    if user.pf?
      CPF.valid?(user.document_cpf) == true
    elsif user.pj?
      CNPJ.valid?(user.document_cnpj) == true
    end
  end

end
