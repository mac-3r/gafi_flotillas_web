class CreateTrailerSubtypes < ActiveRecord::Migration[6.0]
  def change
    create_table :trailer_subtypes do |t|
      t.string :clave
      t.string :nombre
      t.date :fecha_inicio_vigencia
      t.date :fecha_fin_vigencia

      t.timestamps
    end
  end
end
