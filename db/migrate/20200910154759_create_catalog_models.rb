class CreateCatalogModels < ActiveRecord::Migration[6.0]
  def change
    create_table :catalog_models do |t|
      t.string :clave
      t.integer :descripcion
      t.boolean :status
      
      t.timestamps
    end
  end
end
