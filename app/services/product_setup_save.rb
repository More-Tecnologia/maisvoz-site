class ProductSetupSave

  def initialize(form, product_setup = ProductSetup.new)
    @form = form
    @instance = product_setup
  end

  def call
    save!
  end

  attr_reader :form, :instance

  def save!
    instance.installer      = form.installer
    instance.name           = form.name
    instance.document_cpf   = form.document_cpf
    instance.phone          = form.phone
    instance.email          = form.email
    instance.car_brand      = form.car_brand
    instance.car_year       = form.car_year
    instance.car_model      = form.car_model
    instance.car_mileage    = form.car_mileage
    instance.car_plate      = form.car_plate
    instance.product_model  = form.product.name
    instance.product_serial = form.product_serial
    instance.status         = 'pending'
    instance.save!
  end

end
