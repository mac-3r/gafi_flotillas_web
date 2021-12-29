class CreateBimonthlyVerification < ActiveRecord::Migration[6.0]
  def change
    create_table :bimonthly_verifications do |t|
      t.integer :estatus
      t.references :vehicle, null: false, foreign_key: true
      t.references :catalog_personal, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :motivo
      t.date :fecha_captura

      t.timestamps
    end
  end
end
