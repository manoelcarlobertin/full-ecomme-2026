class ChangeLicenseAssociationsToNullable < ActiveRecord::Migration[8.1]
  def change
    # Permite que user_id e order_item_id fiquem vazios (NULL)
    # Isso é essencial para licenças que estão em estoque (status: available)
    change_column_null :licenses, :user_id, true
    change_column_null :licenses, :order_item_id, true
  end
end
