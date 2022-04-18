class CreateMaintenanceBinnacles < ActiveRecord::Migration[6.0]
  def change
    create_table :maintenance_binnacles do |t|
      t.references :catalog_brand, null: false, foreign_key: true
      t.references :concept, null: false, foreign_key: true
      t.boolean :bujias
      t.references :concept_description, null: false, foreign_key: true
      t.string :nombre
      t.string :descripcion
      t.string :categoria
      t.string :linea
      t.integer :tipo_afinacion
      t.integer :tipo_frecuencia
      t.integer :frecuencia_inspeccion
      t.integer :frecuencia_reemplazo
      t.integer :meses
      t.date :fecha
      t.references :vehicle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
