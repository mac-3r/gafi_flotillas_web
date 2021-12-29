class CreateCatalogPersonals < ActiveRecord::Migration[6.0]
  def change
    create_table :catalog_personals do |t|
      t.string :clave
      t.string :nombre
      t.string :apellido

      t.timestamps
    end
  end
end
