class CreateTuningPricesLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :tuning_prices_logs do |t|
      t.string :texto
      t.references :user, null: false, foreign_key: true
      t.references :tuning_price, null: false, foreign_key: true

      t.timestamps
    end
  end
end
