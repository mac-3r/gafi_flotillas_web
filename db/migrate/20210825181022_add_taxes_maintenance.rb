class AddTaxesMaintenance < ActiveRecord::Migration[6.0]
  def change
    add_column :maintenance_controls, :impuestos, :decimal
  end
end
