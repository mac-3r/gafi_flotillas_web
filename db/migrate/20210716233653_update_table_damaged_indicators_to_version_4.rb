class UpdateTableDamagedIndicatorsToVersion4 < ActiveRecord::Migration[6.0]
  def change
    update_view :table_damaged_indicators, version: 4, revert_to_version: 3
  end
end
