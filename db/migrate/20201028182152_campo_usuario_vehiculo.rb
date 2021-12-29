class CampoUsuarioVehiculo < ActiveRecord::Migration[6.0]
  def change
    add_reference :vehicles, :catalog_personal, foreign_key: true
  end
end
