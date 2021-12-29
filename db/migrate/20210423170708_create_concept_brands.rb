class CreateConceptBrands < ActiveRecord::Migration[6.0]
  def change
    create_table :concept_brands do |t|
      t.references :catalog_brand, null: false, foreign_key: true
      t.references :concept_description, null: false, foreign_key: true
      t.decimal :frecuecia_reemplazo
      t.decimal :frecuencia_inspeccion

      t.timestamps
    end
  end
end
