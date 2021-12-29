class UpdateTableDamagedIndicatorsToVersion2 < ActiveRecord::Migration[6.0]
  def change
    update_view :table_damaged_indicators, version: 2, revert_to_version: 1
  end
end
