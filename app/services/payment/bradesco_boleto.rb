module Payment
  class BradescoBoleto

    DEFAULT_HEADERS = {
      'Content-Type'  => 'application/json; charset=utf8',
      'Accept'        => 'application/json',
      'Authorization' => "Basic #{ENV.fetch('BRADESCO_API_KEY')}"
    }

    URL = ('https://' + (ENV.fetch('BRADESCO_SANDBOX') ? 'homolog.' : '') + 'meiosdepagamentobradesco.com.br/apiboleto/transacao').freeze

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
      res = RestClient.post(URL, params.to_json, DEFAULT_HEADERS)
      json = JSON.parse(res.body)
      if res.code == 201
        create_bradesco_transaction(json)
        ShoppingMailer.with(order: order).order_made.deliver_later
      else
        {:error => json['status']['mensagem']}
      end
    end

    def create_payload
      params[:merchant_id] = ENV.fetch('BRADESCO_MERCHANT_ID')
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
        beneficiario: 'MAISVOZ TELECOMUNICAÇÕES EIRELI',
        nosso_numero: 1000 + order.id,
        carteira: 26,
        valor_titulo: order.total_cents,
        data_emissao: today.strftime('%F'),
        data_vencimento: expiration_date.strftime('%F')
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
        tx.boleto_expiration_date = expiration_date.strftime('%F')
        tx.amount_cents           = order.total_cents
        tx.status                 = BradescoTransactionType::BOLETO_GENERATED

        tx.save!
      end
    end

    def expiration_date
      order.expire_at - 3.days > today ? order.expire_at : today + 7.days
    end

    def today
      @today ||= Time.zone.today
    end

  end
end
