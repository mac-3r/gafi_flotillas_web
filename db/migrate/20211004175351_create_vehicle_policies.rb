class CreateVehiclePolicies < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicle_policies do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.references :insurance_policy, null: false, foreign_key: true

      t.timestamps
    end
  end
end
