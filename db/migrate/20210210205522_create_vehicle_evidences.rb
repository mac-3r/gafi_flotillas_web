class CreateVehicleEvidences < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicle_evidences do |t| 
      t.string :imagen
      t.integer :tipo
      t.references :checklist_response, null: true, foreign_key: true
      t.references :vehicles, null: true, foreign_key: true
    end
    add_column :checklist_responses, :motivo, :string
  end
end
