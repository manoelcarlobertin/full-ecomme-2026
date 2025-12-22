module Webhooks
  class JunoController < ApplicationController
    # 1. Ignora a verificação de CSRF (Pois o request vem de fora)
    skip_before_action :verify_authenticity_token
    # 2. Ignora autenticação de usuário (O Juno não está logado no Devise)
    skip_before_action :authenticate_user!, raise: false

    def create
      # 1. Guard Clauses (Segurança básica de lógica)
      # Se não for mudança de status ou não tiver dados, ignora.
      unless params[:eventType] == "CHARGE_STATUS_CHANGED" && params[:data].present?
        head :ok
        return
      end

      # 2. Extração de Dados
      charge_code = params[:data][:chargeId]
      status = params[:data][:status]

      # 3. Busca no Banco de Dados
      # Precisamos achar a Juno::Charge que tem esse código
      juno_charge = Juno::Charge.find_by(code: charge_code)

      if juno_charge.nil?
        # Se não achou, pode ser um boleto de teste ou antigo. Respondemos OK para o Juno não ficar tentando de novo.
        Rails.logger.error "❌ [WEBHOOK] Cobrança não encontrada: #{charge_code}"
        head :ok
        return
      end

      # 4. Atualização do Pedido
      order = juno_charge.order

      # Mapeamento de Status (Juno -> Nossa App)
      case status
      when "PAID"
        order.update!(status: :payment_accepted)
        Rails.logger.info "✅ [WEBHOOK] Pedido ##{order.id} pago com sucesso!"
      when "CANCELLED"
        order.update!(status: :canceled)
        Rails.logger.info "⚠️ [WEBHOOK] Pedido ##{order.id} cancelado."
      end

      head :ok
    end
  end
end