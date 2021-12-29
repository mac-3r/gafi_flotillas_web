class CreateCatalogResponsives < ActiveRecord::Migration[6.0]
  def change
    create_table :catalog_responsives do |t|
      t.string :clave
      t.references :catalog_branch, null: false, foreign_key: true
      t.references :catalog_personal, null: false, foreign_key: true
      t.references :catalog_area, null: false, foreign_key: true
      t.string :correo
      t.boolean :status

      t.timestamps
    end
  end
end
