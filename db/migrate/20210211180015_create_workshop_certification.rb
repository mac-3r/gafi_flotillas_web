class CreateWorkshopCertification < ActiveRecord::Migration[6.0]
  def change
    create_table :workshop_certifications do |t|
      t.integer :numero_ticket
      t.date :fecha
      t.integer :estatus
      t.string :condiciones
      t.references :catalog_workshop, null: false, foreign_key: true
      t.timestamps
    end
  end
end
