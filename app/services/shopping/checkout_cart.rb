module Shopping
  class CheckoutCart

    def initialize(cart:)
      @cart = cart
    end

    def call
      return false unless cart.cart? && cart.total_cents > 0

      update_cart
      generate_boleto
      slack_message

      true
    end

    private

    attr_reader :cart

    def update_cart
      cart.pending_payment!
    end

    def generate_boleto
      BradescoBoletoGeneratorWorker.perform_async(cart.id)
    end

    def slack_message
      SlackMessageWorker.perform_async('#loja', "Pedido *#{cart.hashid}* do usuário *#{cart.user.username}* no valor de *R$ #{cart.total}* realizado...")
    end

  end
end