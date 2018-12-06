class UserSerializer

  def initialize(user)
    @user = user.decorate
  end

  def serialize
    {
      email: user.email,
      name: user.name_or_company_name,
      cpf_cnpj: user.main_document,
      gender: user.gender,
      birthdate: user.birthdate,
      type: user.registration_type,
      zipcode: user.zipcode,
      address_number: user.address_number,
      address: user.address,
      district: user.district,
      state: user.state,
      city: user.city,
      active: user.active,
    }.as_json
  end

  private

  attr_reader :user

end
