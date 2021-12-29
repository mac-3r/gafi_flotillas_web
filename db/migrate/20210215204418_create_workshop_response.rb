class CreateWorkshopResponse < ActiveRecord::Migration[6.0]
  def change
    create_table :workshop_responses do |t|
      t.integer :estatus
      t.string :observacion
      t.references :workshop_certification, null: false, foreign_key: true
      t.references :review_workshop, null: false, foreign_key: true
      t.timestamps
    end
  end
end
