require 'rails_helper'

RSpec.describe Juno::ChargeCreationService do
  # 1. Preparação (Setup)
  let(:order) { create(:order, total_amount: 100.00) }
  # Instanciamos o service
  subject { described_class.new(order) }

  describe '#call' do
    # 2. Definindo o Cenário (Mock)
    before do
      # Aqui está a mágica. Dizemos ao WebMock:
      # "Se alguém tentar fazer um POST na Juno, NÃO vá para a internet."
      # "Em vez disso, retorne status 200 e esse JSON fake."

      stub_request(:post, 'https://sandbox.boletobancario.com/api-integration/charges')
        .with(
          headers: {
            'Content-Type' => 'application/json',
            'X-Api-Version' => '2'
            # Dica Senior: Em testes, ignoramos o token real para não falhar por config
            # 'X-Resource-Token' => anything
          }
        )
        .to_return(
          status: 200,
          body: {
            _embedded: {
              charges: [
                {
                  id: "chr_mocked_123",
                  code: 200,
                  reference: order.id.to_s,
                  dueDate: "2023-12-25",
                  link: "https://sandbox.boletobancario.com/boleto-facil/w/dev/chr_mocked_123",
                  checkoutUrl: "https://sandbox.boletobancario.com/boleto-facil/w/dev/chr_mocked_123",
                  amount: 100.00,
                  status: "ACTIVE"
                }
              ]
            }
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    # 3. Execução e Verificação
    it 'envia a requisição para a Juno corretamente' do
      response = subject.call

      expect(response.code).to eq(200)
      # Verifica se o JSON retornado (que nós mockamos) foi parseado
      parsed = JSON.parse(response.body)
      expect(parsed['_embedded']['charges'].first['id']).to eq('chr_mocked_123')
    end
  end
end
