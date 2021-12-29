class CorrecionCustomers < ActiveRecord::Migration[6.0]
  def change
    remove_column :delivery_addresses, :clave
    add_reference :delivery_addresses, :customer, foreign_key: true
  end
end
