class CreateCatalogVendors < ActiveRecord::Migration[6.0]
  def change
    create_table :catalog_vendors do |t|
      t.string :clave
      t.string :nombre

      t.timestamps
    end
  end
end
