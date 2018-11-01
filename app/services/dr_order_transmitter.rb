class DROrderTransmitter

  URL = 'http://142.93.250.19/index.php/api/Documentos'.freeze
  OK = '200'.freeze

  DEFAULT_HEADERS = {
    'Content-Type'  => 'application/json; charset=utf8',
    'Accept'        => 'application/json'
  }.freeze

  def initialize(order)
    @order = order
  end

  def call
    return if order.dr_recorded?
    return unless order.completed?
    post_order
  end

  private

  attr_reader :order

  def post_order
    res = RestClient.post(URL, serialized_order, DEFAULT_HEADERS)

    order.update!(dr_recorded: true, dr_response: res.body)

    res.body
  rescue RestClient::ExceptionWithResponse => err
    order.update!(dr_response: err.response)
  end

  def serialized_order
    DROrderSerializer.new(order).serialize
  end

end
