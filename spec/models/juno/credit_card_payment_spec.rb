require 'rails_helper'

RSpec.describe Juno::CreditCardPayment, type: :model do
  subject { build(:juno_credit_card_payment) }

  # --- Teste de Sanidade ---
  it 'tem uma factory válida' do
    expect(subject).to be_valid
  end

  # --- Teste de Identidade (Crucial para Namespaces) ---
  # Isso garante que ninguém apague a linha "self.table_name = ..." por engano
  it 'usa a tabela correta no banco de dados' do
    expect(described_class.table_name).to eq('juno_credit_card_payments')
  end

  # --- Associações ---
  # Verificamos se ele sabe quem é o pai, usando a classe certa
  it { is_expected.to belong_to(:charge).class_name('Juno::Charge') }

  # --- Validações Básicas (Opcional, mas recomendado) ---
  # Como unique_id é chave de transação, é bom garantir que exista
  # (Se você não tiver validação no model, este teste vai falhar, então adicione no model se necessário)
  it { is_expected.to validate_presence_of(:unique_id) }
  it { is_expected.to validate_presence_of :status }
end
