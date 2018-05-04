class SAPOrderTransmitter

  URL = 'http://future.ramo.com.br:88/IntegrationOne/api/Documentos'.freeze
  OK = '200'.freeze

  DEFAULT_HEADERS = {
    'Content-Type'  => 'application/json; charset=utf8',
    'Accept'        => 'application/json'
  }.freeze

  def initialize(order)
    @order = order
  end

  def call
    return if order.sap_recorded?
    post_order
    order.update!(sap_recorded: true)
  end

  private

  attr_reader :order

  def post_order
    res = RestClient.post(URL, serialized_order, DEFAULT_HEADERS)

    raise(res.body) if res.code != 200

    res.body
  end

  def serialized_order
    SAPOrderSerializer.new(order).serialize
  end

end
