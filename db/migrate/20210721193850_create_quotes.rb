class CreateQuotes < ActiveRecord::Migration[6.0]
  def change
    create_table :quotes do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.references :service_order, null: false, foreign_key: true
      t.integer :estatus
      t.references :catalog_workshop, null: false, foreign_key: true
      t.string :numero_economico
      t.string :cedis
      t.string :empresa
      t.string :usuario
      t.string :responsable
      t.string :taller_nombre
      t.date :fecha

      t.timestamps
    end
  end
end
