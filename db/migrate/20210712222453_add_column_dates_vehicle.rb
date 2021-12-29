class AddColumnDatesVehicle < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicles, :fecha_vigencia_placas, :date
    add_column :vehicles, :fecha_vigencia_poliza, :date
    add_column :vehicles, :fecha_vigencia_fisico, :date
    add_column :vehicles, :fecha_vigencia_ambiental, :date
  end
end
