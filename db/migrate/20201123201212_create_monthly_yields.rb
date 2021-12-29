class CreateMonthlyYields < ActiveRecord::Migration[6.0]
  def change
    create_table :monthly_yields do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.references :catalog_branch, null: false, foreign_key: true
      t.references :vehicle_type, null: false, foreign_key: true
      t.references :catalog_model, null: false, foreign_key: true
      t.references :catalog_brand, null: false, foreign_key: true
      t.decimal :cierre_enero
      t.decimal :recorrido_enero
      t.decimal :lts_enero
      t.decimal :cierre_febrero
      t.decimal :recorrido_febrero
      t.decimal :lts_febrero
      t.decimal :cierre_marzo
      t.decimal :recorrido_marzo
      t.decimal :lts_marzo
      t.decimal :cierre_abril
      t.decimal :recorrido_abril
      t.decimal :lts_abril
      t.decimal :cierre_mayo
      t.decimal :recorrido_mayo
      t.decimal :lts_mayo
      t.decimal :cierre_junio
      t.decimal :recorrido_junio
      t.decimal :lts_junio
      t.decimal :cierre_julio
      t.decimal :recorrido_julio
      t.decimal :lts_julio
      t.decimal :cierre_agosto
      t.decimal :recorrido_agosto
      t.decimal :lts_agosto
      t.decimal :cierre_septiembre
      t.decimal :recorrido_septiembre
      t.decimal :lts_septiembre
      t.decimal :cierre_octubre
      t.decimal :recorrido_octubre
      t.decimal :lts_octubre
      t.decimal :cierre_noviembre
      t.decimal :recorrido_noviembre
      t.decimal :lts_noviembre
      t.decimal :cierre_diciembre
      t.decimal :recorrido_diciembre
      t.decimal :lts_diciembre
      t.decimal :rendi_enero
      t.decimal :rendi_febrero
      t.decimal :rendi_marzo
      t.decimal :rendi_abril
      t.decimal :rendi_mayo
      t.decimal :rendi_junio
      t.decimal :rendi_julio
      t.decimal :rendi_agosto
      t.decimal :rendi_septiembre
      t.decimal :rendi_octubre
      t.decimal :rendi_noviembre
      t.decimal :rendi_diciembre

      t.timestamps
    end
  end
end
