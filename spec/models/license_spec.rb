require 'rails_helper'

RSpec.describe License, type: :model do
  # criando na memória o objeto subject para ser usado nos testes
  subject { build(:license) }

  # 1. Associações
  it { is_expected.to belong_to(:game) }
  it { is_expected.to belong_to(:order_item).optional }
  it { is_expected.to belong_to(:user).optional }

  # key é obrigatório
  # 2. Validações Básicas
  it { is_expected.to validate_presence_of(:key) }

  # validando uma única chave por plataforma, por isso o 'scoped_to'
  it { is_expected.to validate_uniqueness_of(:key).case_insensitive.scoped_to(:platform) }
  it { is_expected.to validate_presence_of(:platform) }
  it { is_expected.to define_enum_for(:platform).with_values({ steam: 1, battle_net: 2, origin: 3 }) }

  # status é obrigatório
  it { is_expected.to validate_presence_of(:status) }
  # status tem 3 valores possíveis: disponível, em uso, inativo.
  it { is_expected.to define_enum_for(:status).with_values({ available: 1, in_use: 2, inactive: 3 }) }

  # it_behaves_like "paginatable concern", :license

  # 3. Testa o Concern LikeSearchable
  it_behaves_like "like searchable concern", :license, :key

  # 4. Validação de Regra de Negócio (Se estiver em uso, tem que ter dono e pedido)
  context "when status is in_use" do
    before { subject.status = :in_use }

    # CORREÇÃO AQUI TAMBÉM: order_item
    it { is_expected.to validate_presence_of(:order_item) }
    it { is_expected.to validate_presence_of(:user) }
  end
end
