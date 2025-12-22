class ChangeProductableToNullableInProducts < ActiveRecord::Migration[8.1]
  def change
    # Permite que essas colunas recebam valor NULL
    change_column_null :products, :productable_id, true
    # "Tudo bem salvar um Produto sem dono". Não havia Games ainda.
    change_column_null :products, :productable_type, true
  end
end
