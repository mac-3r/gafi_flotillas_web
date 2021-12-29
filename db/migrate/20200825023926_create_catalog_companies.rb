class CreateCatalogCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :catalog_companies do |t|
      t.string :clave
      t.string :nombre
      t.boolean :status
      t.timestamps
    end
  end
end
