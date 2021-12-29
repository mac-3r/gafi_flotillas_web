class CambioTipoMmto < ActiveRecord::Migration[6.0]
  def change
    remove_column :maintenance_programs, :fecha_proximo_servicio
    add_column :maintenance_programs, :fecha_proximo, :date

  end
end
