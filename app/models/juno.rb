module Juno
  class Charge < ApplicationRecord
    # GARANTIA DE DEBUG: Forçamos o nome da tabela para evitar confusão de namespace
    self.table_name = "juno_charges"
    # --- Associações ---
    belongs_to :order
    has_many :credit_card_payments

    # --- Validações Simples ---
    # Agrupamos validações semelhantes para manter o código limpo (DRY).
    # Testes: presence_of :key, :code, :status
    validates :key, :code, :status, presence: true

    # --- Validação de Valor (Amount) ---
    # Testes: presence_of :amount, numericality > 0
    validates :amount, presence: true, numericality: { greater_than: 0 }

    # --- Validação de Número (Number) ---
    # Testes: presence, numericality (int > 0), uniqueness scoped to order
    validates :number, presence: true,
                       numericality: { greater_than: 0, only_integer: true },
                       uniqueness: { scope: :order_id } # Impede que o Pedido #10 tenha duas parcelas com o número "1"
    # Obs: Para inteiros, o case_insensitive é implícito ou desnecessário,
    # mas se fosse string, adicionaríamos: case_sensitive: false
  end
end

# Dica: Se você planeja usar Enums para o status, considere mudar
# a coluna 'status' para integer na migration antes de rodar o migrate.
# enum :status, { created: 0, pending: 1, paid: 2, cancelled: 3, overdue: 4 }
