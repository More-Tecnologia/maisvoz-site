class CheckoutForm < Form
  attribute :order
  attribute :shipping_address
  attribute :custom_shipping_address_postal_code
  attribute :custom_shipping_address_complement
  attribute :custom_shipping_address_number
  attribute :custom_shipping_address_neighborhood
  attribute :custom_shipping_address_street
  attribute :custom_shipping_address_city
  attribute :custom_shipping_address_state
  attribute :custom_shipping_address_country
  attribute :backoffice_shipping_address_postal_code
  attribute :backoffice_shipping_address_complement
  attribute :backoffice_shipping_address_number
  attribute :backoffice_shipping_address_neighborhood
  attribute :backoffice_shipping_address_street
  attribute :backoffice_shipping_address_city
  attribute :backoffice_shipping_address_state
  attribute :backoffice_shipping_address_country
  attribute :user
  attribute :whatsapp

  validates_presence_of :custom_shipping_address_postal_code,
                        :custom_shipping_address_country,
                        :custom_shipping_address_street,
                        :custom_shipping_address_number,
                        :custom_shipping_address_neighborhood,
                        :custom_shipping_address_complement,
                        :custom_shipping_address_city, if: :shipping_address_custom?

  validates_presence_of :backoffice_shipping_address_postal_code,
                        :backoffice_shipping_address_country,
                        :backoffice_shipping_address_street,
                        :backoffice_shipping_address_number,
                        :backoffice_shipping_address_complement,
                        :backoffice_shipping_address_neighborhood,
                        :backoffice_shipping_address_city, if: :shipping_address_backoffice?

  def shipping_address_custom?
    shipping_address.to_s == 'custom'
  end

  def shipping_address_backoffice?
    shipping_address.to_s == 'backoffice'
  end

  def shipping_address_postal_code
    return backoffice_shipping_address_postal_code if shipping_address_backoffice?

    custom_shipping_address_postal_code
  end

  def shipping_address_complement
    return backoffice_shipping_address_complement if shipping_address_backoffice?

    custom_shipping_address_complement
  end

  def shipping_address_street
    return backoffice_shipping_address_street if shipping_address_backoffice?

    custom_shipping_address_street
  end

  def shipping_address_number
    return backoffice_shipping_address_number if shipping_address_backoffice?

    custom_shipping_address_number
  end

  def shipping_address_neighborhood
    return backoffice_shipping_address_neighborhood if shipping_address_backoffice?

    custom_shipping_address_neighborhood
  end

  def shipping_address_city
    return backoffice_shipping_address_city if shipping_address_backoffice?

    custom_shipping_address_city
  end

  def shipping_address_state
    return backoffice_shipping_address_state if shipping_address_backoffice?

    custom_shipping_address_state
  end

  def shipping_address_country
    return backoffice_shipping_address_country if shipping_address_backoffice?

    custom_shipping_address_country
  end

  def backoffice_shipping_address_postal_code
    @backoffice_shipping_address_postal_code.present? ? @backoffice_shipping_address_postal_code : user.try(:zipcode)
  end

  def backoffice_shipping_address_country
    @backoffice_shipping_address_country.present? ? @backoffice_shipping_address_country : user.try(:country)
  end

  def backoffice_shipping_address_complement
    @backoffice_shipping_address_complement.present? ? @backoffice_shipping_address_complement : user.try(:address_2)
  end

  def backoffice_shipping_address_number
    @backoffice_shipping_address_number.present? ? @backoffice_shipping_address_number : user.try(:address_number)
  end

  def backoffice_shipping_address_neighborhood
    @backoffice_shipping_address_neighborhood.present? ? @backoffice_shipping_address_neighborhood : user.try(:district)
  end

  def backoffice_shipping_address_street
    @backoffice_shipping_address_street.present? ? @backoffice_shipping_address_street : user.try(:address)
  end

  def backoffice_shipping_address_city
    @backoffice_shipping_address_city.present? ? @backoffice_shipping_address_city : user.try(:city)
  end

  def backoffice_shipping_address_state
    @backoffice_shipping_address_state.present? ? @backoffice_shipping_address_state : user.try(:state)
  end
end
