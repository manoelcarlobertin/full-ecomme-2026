class CreateAddresses < ActiveRecord::Migration[8.1]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :street
      t.string :number
      t.string :city
      t.string :state
      t.string :zipcode

      t.timestamps
    end
  end
end
