class CreateJunoCreditCards < ActiveRecord::Migration[8.1]
  def change
    create_table :juno_credit_cards do |t|
      t.string :key
      t.string :code
      t.string :number, limit: 4
      t.integer :expiration_month
      t.integer :expiration_year
      t.string :holder_name
      t.string :cpf_cnpj
      t.string :email
      t.string :billet_url

      t.timestamps
    end
  end
end
