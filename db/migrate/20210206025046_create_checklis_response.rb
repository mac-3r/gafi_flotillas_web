class CreateChecklisResponse < ActiveRecord::Migration[6.0]
  def change
    create_table :checklist_responses do |t|
      t.integer :estatus
      t.references :vehicle, null: false, foreign_key: true
      t.references :catalog_personal, null: false, foreign_key: true
      t.date :fecha_captura
      
    end
  end
end
