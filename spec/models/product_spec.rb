# spec/models/product_spec.rb
require 'rails_helper'

RSpec.describe Product, type: :model do
  # build cria uma instância sem salvar no banco de dados
  subject { build(:product) }

  # 1. Teste de Fábrica: Garante que a factory que criamos no Passo 1 é válida
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }

  it { is_expected.to define_enum_for(:status).with_values({ available: 1, unavailable: 2 }) }

  it { is_expected.to validate_presence_of(:featured) }

  # 2. Teste de Relacionamento
  # Adicionamos o .optional para dizer ao teste que isso é permitido
  it { is_expected.to belong_to(:productable).optional }
  it { is_expected.to have_many(:product_categories).dependent(:destroy) }
  it { is_expected.to have_many(:categories).through(:product_categories) }
  it { is_expected.to have_many(:wish_items) }
  # it { is_expected.to have_many(:line_items) }

  # 3. Teste de Escopo Compartilhado (Genérico: nome ou key) por isso 'like'
  # Incluímos os exemplos compartilhados para testar o escopo de busca por nome
  it_behaves_like "like searchable concern", :product, :name

  # Teste extra: Garantir que não criamos produto sem "dono"
  context "validations" do
    it "is valid with valid attributes" do
      product = build(:product)
      expect(product).to be_valid
    end
  end
end
