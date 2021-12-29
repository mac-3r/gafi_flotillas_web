class CambioTipoFecha < ActiveRecord::Migration[6.0]
  def change
    remove_column :consumptions, :fecha_a
    add_column :consumptions, :fecha_aplicacion, :date

  end
end
