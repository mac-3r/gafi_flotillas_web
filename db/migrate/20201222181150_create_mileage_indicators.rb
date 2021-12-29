class CreateMileageIndicators < ActiveRecord::Migration[6.0]
  def change
    create_table :mileage_indicators do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.decimal :km_actual
      t.datetime :fecha

      t.timestamps
    end
  end
end
