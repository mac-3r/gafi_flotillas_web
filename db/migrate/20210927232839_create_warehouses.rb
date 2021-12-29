class CreateWarehouses < ActiveRecord::Migration[6.0]
  def change
    create_table :warehouses do |t|
      t.string :clave
      t.string :descripcion
      t.boolean :estatus, default: true
      
      t.references :catalog_company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
