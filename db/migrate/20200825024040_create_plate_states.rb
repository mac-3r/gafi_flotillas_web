class CreatePlateStates < ActiveRecord::Migration[6.0]
  def change
    create_table :plate_states do |t|
      t.string :clave
      t.string :descripcion
      t.boolean :status

      t.timestamps
    end
  end
end
