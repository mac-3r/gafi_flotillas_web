class CreatePerformTargets < ActiveRecord::Migration[6.0]
  def change
    create_table :perform_targets do |t|
      t.string :clave
      t.integer :objperform
      t.references :catalog_branch, null: false, foreign_key: true
      t.references :vehicle_type, null: false, foreign_key: true
      t.integer :idealperform
      t.boolean :status

      t.timestamps
    end

    add_index :perform_targets, [:catalog_branch_id, :idealperform], unique:true
  end
end
