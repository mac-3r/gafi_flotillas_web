class AddNfacturaConsumption < ActiveRecord::Migration[6.0]
  def change
    add_column :consumptions, :n_factura, :string
    add_column :consumptions, :pdf, :string
  end
end
