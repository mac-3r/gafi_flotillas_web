class CreateMaintenanceLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :maintenance_logs do |t|
      t.string :clave
      t.references :catalog_brand, null: false, foreign_key: true
      t.date :fecha

      t.timestamps
    end
  end
end
