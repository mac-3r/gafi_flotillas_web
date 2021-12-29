class CreatePoll < ActiveRecord::Migration[6.0]
  def change
    create_table :polls do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.references :catalog_workshop, null: false, foreign_key: true
      t.references :service_order, null: false, foreign_key: true
      t.integer :ponderacion
      t.timestamps 
    end
  end
  add_reference :notifications, :service_order, foreign_key: true
end
