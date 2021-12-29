class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.string :clave
      t.references :catalog_branch, null: false, foreign_key: true
      t.references :catalog_company, null: false, foreign_key: true
      t.integer :estatus

      t.timestamps
    end
  end
end
