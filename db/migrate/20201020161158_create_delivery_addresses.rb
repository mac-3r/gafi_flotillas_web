class CreateDeliveryAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :delivery_addresses do |t|
      t.references :catalog_company, null: false, foreign_key: true
      t.string :clave
      t.string :principal
      t.references :catalog_branch, null: false, foreign_key: true
      t.string :direccion
      t.integer :estatus

      t.timestamps
    end
  end
end
