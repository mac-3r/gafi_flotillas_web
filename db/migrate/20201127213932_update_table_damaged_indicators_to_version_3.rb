class UpdateTableDamagedIndicatorsToVersion3 < ActiveRecord::Migration[6.0]
  def change
    update_view :table_damaged_indicators, version: 3, revert_to_version: 2
  end
end
