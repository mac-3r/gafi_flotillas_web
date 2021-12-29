class CreatePermissionTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :permission_types do |t|
      t.string :clave
      t.text :descripcion
      t.string :clave_transporte
      t.date :fecha_inicio_vigencia
      t.date :fecha_fin_vigencia

      t.timestamps
    end
  end
end
