class CreateChecklisResponseDetail < ActiveRecord::Migration[6.0]
  def change
    create_table :checklist_response_details do |t|
     # t.references :catalog_personal, null: false, foreign_key: true
      t.references :checklist_response, null: false, foreign_key: true
      t.references :vehicle_checklist, null: false, foreign_key: true
      t.integer :estatus 
      
    end
  end
end
