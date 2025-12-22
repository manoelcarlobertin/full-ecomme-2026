class AddFieldsToLicenses < ActiveRecord::Migration[8.1]
  def change
    add_reference :licenses, :user, null: false, foreign_key: true
    add_reference :licenses, :order_item, null: false, foreign_key: true
  end
end
