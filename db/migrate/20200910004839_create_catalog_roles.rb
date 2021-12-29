class CreateCatalogRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :catalog_roles do |t|
      t.string :clave
      t.string :nombre
      t.string :descripcion
      t.boolean :status
      t.timestamps
    end
  end
end
