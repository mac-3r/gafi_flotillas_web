class CreateCatalogRepairs < ActiveRecord::Migration[6.0]
  def change
    create_table :catalog_repairs do |t|
      t.string :clave
      t.string :categoria
      t.string :subcategoria
      t.boolean :status

      t.timestamps
    end
  end
end
