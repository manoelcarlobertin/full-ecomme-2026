class AddFinancialsToOrders < ActiveRecord::Migration[8.1]
  def change
    # Adicionamos os campos com precisão monetária correta
    add_column :orders, :subtotal, :decimal, precision: 14, scale: 2
    add_column :orders, :total_amount, :decimal, precision: 14, scale: 2

    # Dica Senior: É bom definir um default, mas cuidado com regras de negócio.
    # Aqui vamos deixar nil: false apenas se você garantir que sempre cria com valor.
    # Por segurança agora, deixaremos aceitar null temporariamente ou definiremos default: 0
    # Mas como sua factory gera valor, vamos apenas criar as colunas.
  end
end
