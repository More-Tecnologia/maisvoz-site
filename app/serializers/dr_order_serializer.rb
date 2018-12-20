class DROrderSerializer

  FILIAL_GOIANIA = {
    code: 2,
    deposito: '02'
  }.freeze

  FILIAL_SAO_PAULO = {
    code: 1,
    deposito: '01'
  }.freeze

  def initialize(order, filial = FILIAL_GOIANIA)
    @order  = order
    @user   = order.user.decorate
    @filial = filial
  end

  def serialize
    {
      token: '/XZ9qjPSDYF938+7rN5SAw==',
      id: "O#{order.id}",
      tipoDocumento: 17,
      produtoServico: 'P',
      dataLancamento: order.created_at.iso8601,
      dataVencimento: order.created_at.iso8601,
      observacao: '',
      filial: filial[:code],
      condicaoPagamento: 14,
      formaPagamento: 'Boleto Bradesco',
      modFrete: '9',
      codigoVendedor: 2,
      parceiroNegocio: user_attrs,
      linhas: order_items,
      pagamento: pagamento_attrs
    }.to_json
  end

  private

  attr_reader :order, :user, :filial

  def user_attrs
    {
      codigoSap: '',
      codigoIntegracao: "C#{user.id}",
      razaoSocial: I18n.transliterate(user.name_or_company_name),
      fantasia: I18n.transliterate(user.document_fantasy_name),
      FornecedorCliente: 'C',
      codigoGrupo: 100,
      descricaoGrupo: 'Clientes',
      cnpj: user.document_cnpj_digits,
      cpf: user.document_cpf_digits,
      inscricaoEstadual: user.document_ie,
      telefone: phone,
      telefone2: '',
      site: nil,
      comentario: nil,
      textoLivre: "username: #{user.username}",
      tipoLogradouro: '',
      endereco: user.address,
      numero: user.pretty_address_number,
      complemento: user.address_2,
      bairro: user.district,
      cep: user.zipcode,
      cidade: user.city,
      uf: user.state,
      pais: user.country,
      municipio: user.city,
      codigoIbge: address_ibge,
      email: user.email
    }
  end

  def order_items
    order.order_items.map do |item|
      {
        item: {
          codigoSap: item.product.id.to_s
        },
        quantidade: item.quantity,
        preco: item.unit_price.to_f,
        deposito: filial[:deposito],
        utilizacao: 9
      }
    end
  end

  def pagamento_attrs
    {
      transfConta: '1.1.01.02.004',
      transfValor: order.total.to_f
    }
  end

  def address_ibge
    City.find_by(name: user.city).ibge
  end

  def phone
    user.phone || '(62) 3988-8067'
  end

end
