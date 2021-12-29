class CambioConsumptionsFecha < ActiveRecord::Migration[6.0]
  def change
    add_column :consumptions, :fecha_factura, :datetime
  end
end
