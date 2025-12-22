module Juno
  class CreditCardPayment < ApplicationRecord
    # 1. IDENTIDADE: Forçamos o Rails a olhar para a tabela correta
    self.table_name = "juno_credit_card_payments"

    # 2. RELACIONAMENTO: Explicitamos tudo
    # class_name: Quem é o pai?
    # foreign_key: Qual o nome da coluna no MEU banco de dados?
    belongs_to :charge, class_name: "Juno::Charge", foreign_key: :charge_id

    # ... validações ...
    # Garantimos que não salvamos pagamentos vazios
    validates :unique_id, presence: true
    validates :status, presence: true
  end
end
