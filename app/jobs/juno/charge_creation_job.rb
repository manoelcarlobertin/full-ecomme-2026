module Juno
  class ChargeCreationJob < ApplicationJob
    queue_as :default

    # O erro mostra que ele recebe (self, order_attrs), ou seja, (order, attributes)
    def perform(order, _order_attributes = nil)
      # 1. Aqui chamaremos o Service Object novo para falar com a API
      response = Juno::ChargeCreationService.new(order).call
      Rails.logger.info "Juno Charge Job iniciado para o pedido #{order.id}"

      # 2. Verifica se deu certo (HTTP 200 OK)
      if response.success?
        charge_data = response.parsed_response['_embedded']['charges'].first

        # 3. Cria o registro no nosso banco de dados (Juno::Charge)
        Juno::Charge.create!(
          order: order,
          key: charge_data['id'],
          code: charge_data['code'],
          number: charge_data['serialNumber'],
          amount: charge_data['amount'],
          status: charge_data['status'],
          billet_url: charge_data['billetDetails'] ? charge_data['billetDetails']['bankAccount'] : nil
        )

        Rails.logger.info "Cobrança criada com sucesso na Juno: #{charge_data['id']}"

        # --- A MÁGICA DO HOTWIRE ---
        # BroadcastReplaceTo: "Ei, quem estiver ouvindo o canal 'order',
        # substitua o elemento HTML com ID 'dom_id(order, :payment_area)'
        # pelo conteúdo do partial 'checkout/payment_button'."
        order.broadcast_replace_to(
          order,
          target: ActionView::RecordIdentifier.dom_id(order, :payment_area),
          partial: "checkout/payment_button",
          locals: { order: order }
        )

      else
        # Se falhar, podemos avisar a tela também (opcional)
        # order.broadcast_replace_to(...)
        # Abaixo, logamos o erro (ou poderíamos lançar exceção para tentar de novo)
        Rails.logger.error "Erro ao criar cobrança na Juno: #{response.body}"
      end
    end
  end
end
