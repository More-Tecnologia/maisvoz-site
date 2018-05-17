class SAPOrderSerializer

  FILIAL_GOIANIA = 3

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
      dataLancamento: order.created_at.rfc3339,
      dataVencimento: order.created_at.rfc3339,
      observacao: '',
      filial: filial,
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
      razaoSocial: user.name_or_company_name,
      fantasia: user.document_fantasy_name,
      FornecedorCliente: 'C',
      codigoGrupo: 101,
      descricaoGrupo: 'Clientes',
      cnpj: user.document_cnpj_digits,
      cpf: user.document_cpf_digits,
      inscricaoEstadual: user.document_ie,
      telefone: user.phone,
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
          codigoSap: item.product.sap_code
        },
        quantidade: item.quantity,
        preco: item.unit_price.to_f,
        deposito: '01',
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

end
