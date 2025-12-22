class AddDocumentToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :document, :string
    add_index :users, :document # Melhora performance de busca
  end
end
