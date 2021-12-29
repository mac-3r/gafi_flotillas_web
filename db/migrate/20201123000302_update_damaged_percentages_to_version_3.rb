class UpdateDamagedPercentagesToVersion3 < ActiveRecord::Migration[6.0]
  def change
    update_view :damaged_percentages, version: 3, revert_to_version: 2
  end
end
