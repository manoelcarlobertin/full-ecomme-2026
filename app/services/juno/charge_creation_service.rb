require "httparty"
# Classe responsável por criar uma cobrança na Juno
module Juno
  class ChargeCreationService
    include HTTParty
    # Define a URL base. Em produção, você usaria ENV['JUNO_ENDPOINT']
    base_uri "https://sandbox.boletobancario.com/api-integration"

    def initialize(order)
      @order = order
      @headers = {
        'X-Resource-Token' => ENV['JUNO_PRIVATE_TOKEN'], # Token Privado da Juno
        'X-Api-Version' => '2',
        'Content-Type' => 'application/json'
      }
    end

    def call
      # Montamos o corpo da requisição
      body = build_payload

      # Fazemos o POST para o endpoint /charges
      response = self.class.post('/charges', headers: @headers, body: body.to_json)

      # Retornamos a resposta crua para quem chamou decidir o que fazer
      response
    end

    private

    def build_payload
      {
        charge: {
          description: "Pedido ##{@order.id} - Loja Virtual",
          amount: @order.total_amount.to_f, # Juno espera Float ou Decimal
          references: [@order.id.to_s],
          paymentTypes: ["CREDIT_CARD"], # Ou ['BOLETO'] dependendo da lógica
          paymentAdvance: false # Se quer adiantamento de recebíveis (normalmente false)
        },
        billing: {
          name: @order.user.name, # Assumindo que User tem name
          document: @order.user.document || "000.000.000-00", # CPF
          email: @order.user.email,
          # Endereço é obrigatório para antifraude
          address: {
            street: @order.address&.street || "Rua Teste",
            number: @order.address&.number || "123",
            city: @order.address&.city || "Cidade",
            state: @order.address&.state || "SP",
            postCode: @order.address&.zipcode || "00000-000"
          }
        }
      }
    end
  end
end
