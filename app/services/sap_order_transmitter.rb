class SAPOrderTransmitter

  URL = 'http://future.ramo.com.br:88/IntegrationOne/api/Documentos'.freeze
  OK = '200'.freeze

  DEFAULT_HEADERS = {
    'Content-Type'  => 'application/json; charset=utf8',
    'Accept'        => 'application/json'
  }.freeze

  def initialize(order, filial = 1)
    @order  = order
    @filial = filial
  end

  def call
    return if order.sap_recorded?
    post_order
  end

  private

  attr_reader :order, :filial

  def post_order
    res = RestClient.post(URL, serialized_order, DEFAULT_HEADERS)

    order.update!(sap_recorded: true, sap_response: res.body)

    res.body
  rescue RestClient::ExceptionWithResponse => err
    order.update!(sap_response: err.response)
  end

  def serialized_order
    SAPOrderSerializer.new(order, filial).serialize
  end

end
