module Juno
  class Charge < ApplicationRecord
    self.table_name = "juno_charges"

    belongs_to :order

    # CORREÇÃO:
    # Explicitamos o nome da classe (para garantir que ele ache dentro do namespace)
    # Explicitamos a foreign_key (para ele usar charge_id em vez de juno_charge_id)
    has_many :credit_card_payments,
             class_name: "Juno::CreditCardPayment",
             foreign_key: :charge_id,
             dependent: :destroy # Boa prática: se apagar a cobrança, apaga as tentativas de pagamento

    # ... suas validações ...
  end
end
