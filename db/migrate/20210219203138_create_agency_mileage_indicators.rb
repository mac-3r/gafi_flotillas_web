class CreateAgencyMileageIndicators < ActiveRecord::Migration[6.0]
  def change
    create_table :agency_mileage_indicators do |t|
      t.decimal :km_actual
      t.references :vehicle, null: false, foreign_key: true
      t.datetime :fecha
      t.string :tipo

      t.timestamps
    end
    add_column :mileage_indicators, :tipo, :string
  end
end
