class AddColumnVehicleAdaptations < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_adaptations, :fecha_factura, :date
    add_column :vehicle_adaptations, :importe_iva, :decimal
    add_column :vehicle_adaptations, :uuid, :string
    add_column :vehicle_adaptations, :n_factura, :string
    add_reference :vehicle_adaptations, :catalog_vendor, foreign_key: true
  end
end
