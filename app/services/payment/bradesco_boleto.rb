module Payment
  class BradescoBoleto

    DEFAULT_HEADERS = {
      'Content-Type'  => 'application/json; charset=utf8',
      'Accept'        => 'application/json',
      'Authorization' => "Basic #{ENV.fetch('BRADESCO_API_KEY')}"
    }

    def initialize(order)
      @order  = order
      @user   = order.user.decorate
      @params = {}
    end

    def call
      create_payload
      create_boleto
    end

    private

    attr_reader :order, :user, :params

    def create_boleto
      res = RestClient.post(url, params.to_json, DEFAULT_HEADERS)
      if res.code == 201
        json = JSON.parse(res.body)
        create_bradesco_transaction(json)
        ShoppingMailer.with(order: order).order_made.deliver_later
      else
        raise res.body
      end
    end

    def create_payload
      params[:merchant_id] = '100007991'
      params[:meio_pagamento] = '300'
      params[:pedido] = {
        numero: order.id,
        valor: order.total_cents
      }
      params[:comprador] = {
        nome: user.name,
        documento: user.main_document.scan(/\d+/).join
      }
      params[:comprador][:endereco] = {
        cep: user.zipcode.scan(/\d+/).join,
        logradouro: user.address,
        numero: user.pretty_address_number,
        bairro: user.district,
        cidade: user.city,
        uf: user.state
      }
      params[:boleto] = {
        beneficiario: 'Future Motors Ltda',
        nosso_numero: 1000 + order.id,
        carteira: 26,
        valor_titulo: order.total_cents,
        data_emissao: Time.zone.today,
        data_vencimento: expiration_date
      }
      params[:token_request_confirmacao_pagamento] = order.token
    end

    def create_bradesco_transaction(res)
      BradescoTransaction.new.tap do |tx|
        tx.provider_response      = res
        tx.user                   = user
        tx.order                  = order
        tx.boleto_url             = res['boleto']['url_acesso']
        tx.boleto_barcode         = res['boleto']['linha_digitavel']
        tx.boleto_expiration_date = Time.zone.today + 7.days
        tx.amount_cents           = order.total_cents
        tx.status                 = BradescoTransactionType::BOLETO_GENERATED

        tx.save!
      end
    end

    def expiration_date
      order.expire_at || Time.zone.today + 7.days
    end

    def url
      ENV.fetch('BRADESCO_API_URL')
    end

  end
end
