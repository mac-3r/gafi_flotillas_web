class CreateCatalogConsiderations < ActiveRecord::Migration[6.0]
  def change
    create_table :catalog_considerations do |t|
      t.string :clave
      t.references :catalog_brand, null: false, foreign_key: true
      t.string :descripcion

      t.timestamps
    end
  end
end
