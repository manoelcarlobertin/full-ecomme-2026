# Em spec/models/juno/charge_spec.rb ou similar
require 'rails_helper'

RSpec.describe Juno::Charge, type: :model do
  subject { build(:juno_charge) }

  # --- Teste de Validade Geral ---
  it 'é válido com atributos válidos' do
    expect(subject).to be_valid
  end

  # --- Associações ---
  it { is_expected.to belong_to :order }

  it 'consegue ter pagamentos de cartão associados' do
    charge = create(:juno_charge)
    # Tenta criar um pagamento associado a essa cobrança
    payment = Juno::CreditCardPayment.create(charge: charge, unique_id: '123', status: 'CONFIRMED')

    # Verifica se o pagamento foi salvo e se está na lista da cobrança
    expect(payment).to be_persisted
    expect(charge.credit_card_payments).to include(payment)
  end

  # --- Validações ---
  it { is_expected.to validate_presence_of :key }
  it { is_expected.to validate_presence_of :code }

  # Number
  it { is_expected.to validate_presence_of(:number) }
  it { is_expected.to validate_uniqueness_of(:number).scoped_to(:order_id).ignoring_case_sensitivity }
  it { is_expected.to validate_numericality_of(:number).is_greater_than(0).only_integer }

  # Amount
  it { is_expected.to validate_presence_of(:amount) }
  it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }

  # Status
  it { is_expected.to validate_presence_of :status }
end
