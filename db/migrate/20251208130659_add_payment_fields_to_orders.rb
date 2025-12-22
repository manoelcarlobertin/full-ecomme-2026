class AddPaymentFieldsToOrders < ActiveRecord::Migration[8.1]
  def change
    # 1. Payment Type
    # Senior Tip: Usamos integer para trabalhar com ENUMs no Rails (mais rápido e eficiente)
    add_column :orders, :payment_type, :integer, default: 0

    # 2. Dados do Cartão
    add_column :orders, :card_hash, :string

    # 3. Parcelamento
    add_column :orders, :installments, :integer, default: 1

    # 4. Documento (CPF/CNPJ)
    # Se já existir na tabela users, talvez seja redundante aqui,
    # mas como a Factory pede no Order, vamos adicionar para destravar.
    add_column :orders, :document, :string
  end
end
