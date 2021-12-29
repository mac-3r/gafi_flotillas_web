class CreateBimonthlyDetail < ActiveRecord::Migration[6.0]
  def change
    create_table :bimonthly_details do |t|
      t.references :bimonthly_verification, null: false, foreign_key: true
      t.references :vehicle_checklist, null: false, foreign_key: true
      t.integer :estatus 
      t.timestamps
    end
  end
end
