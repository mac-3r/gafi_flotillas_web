class CambiosProveedoresConsumptions < ActiveRecord::Migration[6.0]
  def change
    add_column :consumptions, :fecha_a, :string
    add_column :catalog_vendors, :cuenta_bancaria, :string
  end
end
