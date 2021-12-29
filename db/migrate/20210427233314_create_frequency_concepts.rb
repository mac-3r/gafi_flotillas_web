class CreateFrequencyConcepts < ActiveRecord::Migration[6.0]
  def change
    remove_column :concept_brands, :frecuecia_reemplazo
    remove_column :concept_brands, :frecuencia_inspeccion
    remove_column :concept_brands, :tipo_frecuencia
    remove_column :concept_brands, :meses
    remove_column :concept_brands, :fecha
    add_column :concept_brands, :estatus, :boolean, default: true
    create_table :frequency_concepts do |t|
      t.references :concept_brand, foreign_key: true
      t.references :catalog_brand, foreign_key: true
      t.float :frecuencia_reemplazo
      t.float :frecuencia_inspeccion
      t.integer :tipo_frecuencia
      t.integer :meses
      t.date :fecha
      t.boolean :estatus, default: true

      t.timestamps
    end
  end
end
