class CreateTableDamagedIndicators < ActiveRecord::Migration[6.0]
  def change
    create_view :table_damaged_indicators
  end
end
