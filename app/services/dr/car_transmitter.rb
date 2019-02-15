module Dr
  class CarTransmitter

    URL = 'http://142.93.250.19/index.php/api/Veiculos'.freeze
    OK = '200'.freeze

    DEFAULT_HEADERS = {
      'Content-Type' => 'application/json; charset=utf8',
      'Accept'       => 'application/json'
    }.freeze

    def initialize(subscription)
      @subscription = subscription
    end

    def call
      post_subscription
    end

    private

    attr_reader :subscription

    def post_subscription
      res = RestClient.post(URL, serialized_subscription, DEFAULT_HEADERS)

      subscription.update!(dr_recorded: true, dr_response: res.body)

      res.body
    rescue RestClient::ExceptionWithResponse => err
      subscription.update!(dr_response: err.response)
    end

    def serialized_subscription
      {
        token: '/XZ9qjPSDYF938+7rN5SAw==',
        id: subscription.id,
        user_cnpj_cpf: subscription.user.decorate.main_document,
        car_model: subscription.car_model.name,
        chassis: subscription.chassis,
        plate: subscription.plate,
        car_owner_cnpj_cpf: subscription.cnpj_cpf,
        owner_name: subscription.owner_name,
        manufacture_year: subscription.manufacture_year,
        model_year: subscription.model_year,
        fuel: subscription.fuel,
        mileage: subscription.mileage,
        renavem: subscription.renavam,
        gearbox: subscription.gearbox,
        taxi: subscription.taxi,
        mercosul_code: subscription.mercosul_code,
        color: subscription.color,
        color_type: subscription.color_type,
        origin: subscription.origin,
        type: subscription.type
      }.to_json
    end

  end
end
