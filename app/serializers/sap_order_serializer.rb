class SAPOrderSerializer

  def initialize(order)
    @order = order
    @user = order.user.decorate
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
      filial: 1,
      condicaoPagamento: 14,
      formaPagamento: 'Boleto Bradesco',
      codigoVendedor: 2,
      parceiroNegocio: user_attrs,
      linhas: order_items,
      pagamento: pagamento_attrs
    }.to_json
  end

  private

  attr_reader :order, :user

  def user_attrs
    {
      codigoSap: '',
      codigoIntegracao: 'C991',
      razaoSocial: user.name_or_company_name,
      fantasia: user.document_fantasy_name,
      FornecedorCliente: 'C',
      codigoGrupo: 103,
      descricaoGrupo: 'Clientes',
      cnpj: user.document_cnpj,
      cpf: user.document_cpf,
      inscricaoEstadual: user.document_ie,
      telefone: user.phone,
      telefone2: '',
      site: nil,
      comentario: nil,
      textoLivre: "username: #{user.username}",
      tipoLogradouro: '',
      endereco: user.address,
      numero: user.address_number,
      complemento: user.address_2,
      bairro: user.district,
      cep: user.zipcode,
      cidade: user.city,
      uf: user.state,
      pais: user.country,
      municipio: user.city,
      codigoIbge: user.address_ibge,
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

end
