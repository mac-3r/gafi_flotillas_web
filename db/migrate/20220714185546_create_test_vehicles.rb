class CreateTestVehicles < ActiveRecord::Migration[6.0]
  def change
    create_table :test_vehicles do |t|
      t.string :nombre
      t.integer :numero

      t.timestamps
    end
  end
end
