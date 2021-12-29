class UpdateDamagedPercentagesToVersion7 < ActiveRecord::Migration[6.0]
  def change
    update_view :damaged_percentages, version: 7, revert_to_version: 6
  end
end
