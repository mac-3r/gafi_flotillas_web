class CreateVehicleBrands < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicle_brands do |t|
      t.string :descripcion
      t.boolean :status

      t.timestamps
    end
  end
end
