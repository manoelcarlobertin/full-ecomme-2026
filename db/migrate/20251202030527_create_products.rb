class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.references :productable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
