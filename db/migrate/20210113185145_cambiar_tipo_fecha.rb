class CambiarTipoFecha < ActiveRecord::Migration[6.0]
  def change
    change_column :maintenance_appointments, :fecha_cita, :datetime
  end
end
