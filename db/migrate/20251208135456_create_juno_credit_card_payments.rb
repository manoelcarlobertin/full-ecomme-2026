class CreateJunoCreditCardPayments < ActiveRecord::Migration[8.1]
  def change
    create_table :juno_credit_card_payments do |t|
      # foreign_key: { to_table: :juno_charges } garante o apontamento correto para a tabela certa
      t.references :charge, null: false, foreign_key: { to_table: :juno_charges }
      t.string :unique_id
      t.string :status

      t.timestamps
    end
  end
end
