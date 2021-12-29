class CreateAdditionalServices < ActiveRecord::Migration[6.0]
  def change
    create_table :additional_services do |t|
      t.integer :clave
      t.string :descripcion
      t.decimal :costo
      t.references :service_order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
