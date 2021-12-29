class CreateCatalogLicences < ActiveRecord::Migration[6.0]
  def change
    create_table :catalog_licences do |t|
      t.string :clave
      t.string :descripcion

      t.timestamps
    end
  end
end
