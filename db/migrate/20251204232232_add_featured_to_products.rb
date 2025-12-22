class AddFeaturedToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :featured, :boolean, default: false
  end
end

# Mais um campo em products que será utilizado para marcar e destacar produtos na loja.
