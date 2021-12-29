class CreateCatalogWorkshops < ActiveRecord::Migration[6.0]
  def change
    create_table :catalog_workshops do |t|
      t.string :clave
      t.references :catalog_branch, null: false, foreign_key: true
      t.string :nombre_taller
      t.string :razonsocial
      t.string :especialidad
      t.string :responsable
      t.string :telefono
      t.string :domicilio
      t.string :correo
      t.boolean :vigente

      t.timestamps
    end
  end
end
