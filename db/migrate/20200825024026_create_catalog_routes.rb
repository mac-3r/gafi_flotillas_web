class CreateCatalogRoutes < ActiveRecord::Migration[6.0]
  def change
    create_table :catalog_routes do |t|
      t.string :clave
      t.string :descripcion
      t.boolean :status

      t.timestamps
    end
  end
end
