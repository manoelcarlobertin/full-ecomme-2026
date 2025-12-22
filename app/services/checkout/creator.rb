module Checkout
  class Creator
    def initialize(user:, cart_ids:)
      @user = user
      @cart_ids = cart_ids
    end

    def call
      return false if @cart_ids.blank?

      # Inicia uma transação: Se der erro em qualquer linha aqui dentro,
      # o Rails desfaz tudo (Rollback) automaticamente.
      ActiveRecord::Base.transaction do
        # 1. Cria o Pedido
        order = Order.create!(
          user: @user,
          status: :waiting_payment,
        )

        # 2. Busca os produtos
        products = Product.where(id: @cart_ids)

        # 3. Cria os OrderItems (Congelando o preço atual)
        products.each do |product|
          OrderItem.create!(
            order: order,
            product: product,
            quantity: 1, # Por enquanto fixo em 1 (para licenças digitais faz sentido)
            payed_price: product.price
          )
        end

        # Retorna o pedido criado
        order
      end
    rescue ActiveRecord::RecordInvalid => e
      puts Rails.logger.error e.message
      false
    end
  end
end
