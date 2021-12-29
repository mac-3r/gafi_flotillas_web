class CreateJdeVehiclesLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :jde_vehicles_logs do |t|
      t.date :fecha
      t.datetime :hora
      t.text :json_enviado
      t.string :respuesta
      t.references :vehicle, null: false, foreign_key: true
      t.string :trailer_id
      t.string :tipo

      t.timestamps
    end
  end
end
