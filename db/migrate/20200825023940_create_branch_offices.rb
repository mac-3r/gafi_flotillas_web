class CreateBranchOffices < ActiveRecord::Migration[6.0]
  def change
    create_table :branch_offices do |t|
      t.references :catalog_company, null: false, foreign_key: true
      t.string :clave_clasificacion
      t.string :clave_jd
      t.string :descripcion
      t.string :unidad_negocio
      t.boolean :status

      t.timestamps
    end
  end
end
