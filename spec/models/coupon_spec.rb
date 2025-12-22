require 'rails_helper'

RSpec.describe Coupon, type: :model do
  # 1. Testes de Validações Básicas (Shoulda Matchers)
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:status) }
  # Teste de Enum abaixo
  it { is_expected.to define_enum_for(:status).with_values(active: 1, inactive: 2) }
  it { is_expected.to validate_presence_of(:due_date) }
  it { is_expected.to validate_presence_of(:discount_value) }
  it { is_expected.to validate_presence_of(:max_use) }

  it { is_expected.to validate_numericality_of(:discount_value).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:max_use).only_integer.is_greater_than_or_equal_to(0) }

  # 2. Teste de Unicidade do Código (Case Insensitive)
  # Ex: "PROMO10" deve ser igual a "promo10" e bloquear a criação
  describe "uniqueness" do
    # O RSpec precisa de um registro existente na memória para comparar com o novo
    subject { build(:coupon) }
    it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
  end

  # 3. Teste da Regra de Data (Custom Validation)
  describe "due_date validations" do
    context "when creating a new coupon" do
      it "is valid with a future date" do
        coupon = build(:coupon, due_date: 1.day.from_now)
        expect(coupon).to be_valid
      end

      it "is invalid with a past date" do
        coupon = build(:coupon, due_date: 1.day.ago)

        # Esperamos que seja inválido
        expect(coupon).to be_invalid

        # Esperamos uma mensagem de erro específica no campo due_date
        expect(coupon.errors[:due_date]).to include("não pode estar no passado")
      end

      it "is invalid with current date (depending on logic)" do
        # Se sua regra for "tem que ser maior que agora", "agora" falha.
        # Se for "maior ou igual", passa. Vamos assumir que criamos para o futuro.
        coupon = build(:coupon, due_date: Time.zone.now - 1.minute)
        expect(coupon).to be_invalid
      end
    end

    context "when updating an existing coupon" do
      it "allows past dates" do
        # Regra de negócio: Se o cupom já existe e venceu ontem,
        # eu devo poder editar o nome dele sem que a validação de data bloqueie.
        coupon = create(:coupon, due_date: 1.day.from_now)

        # Viajamos no tempo para o futuro onde o cupom venceu
        travel_to 2.days.from_now do
          coupon.name = "Novo Nome Editado"
          expect(coupon).to be_valid
        end
      end
    end
  end
end
