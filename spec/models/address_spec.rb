require 'rails_helper'

RSpec.describe Address, type: :model do
  # Usa a factory que já configuramos
  subject { build(:address) }

  # Teste de Sanidade
  it 'é válido com atributos válidos' do
    expect(subject).to be_valid
  end

  # Associações
  it { is_expected.to belong_to(:user) }

  # Opcional: Se Order pertencer a Address no futuro, adicionamos aqui.
  # Por enquanto, Order pertence a Address (has_many orders?), ou Address pertence a Order?
  # No seu diagrama atual, Address é um dado do usuário, e a Order usa esse dado.

  # Validações (Garanta que seu model app/models/address.rb tenha validates presence)
  it { is_expected.to validate_presence_of(:street) }
  it { is_expected.to validate_presence_of(:number) }
  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_presence_of(:state) }
  it { is_expected.to validate_presence_of(:zipcode) }
end
