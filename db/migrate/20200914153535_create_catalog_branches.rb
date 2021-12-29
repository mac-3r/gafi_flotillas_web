class CreateCatalogBranches < ActiveRecord::Migration[6.0]
  def change
    create_table :catalog_branches do |t|
      t.string :clave
      t.string :clave_jd
      t.string :decripcion
      t.references :catalog_company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
