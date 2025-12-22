class Coupon < ApplicationRecord
  class InvalidUse < StandardError; end

  # Enum para controlar se o cupom está valendo ou não
  enum :status, { active: 1, inactive: 2 }

  validates :name, presence: true
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :status, presence: true
  validates :discount_value, presence: true, numericality: { greater_than: 0 }
  validates :max_use, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :due_date, presence: true

  # Validação customizada: Não permitir criar cupom vencido
  validate :due_date_cannot_be_in_the_past, on: :create

  private

  # def validate_use! # Método para validar se o cupom pode ser usado
  #   raise InvalidUse unless self.active? && self.due_date >= Time.now
  #   true
  # end

  def due_date_cannot_be_in_the_past # Validação customizada
    if due_date.present? && due_date < Time.zone.now
      errors.add(:due_date, "não pode estar no passado")
    end
  end
end
