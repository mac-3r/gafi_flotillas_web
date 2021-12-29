class CreatePermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :permissions do |t|
      t.string :nombre
      t.string :accion
      t.string :clase
      t.text :descripcion
      t.integer :clase_id
      t.text :menu
      t.text :opcion
      t.timestamps
    end
  end
end
