class UpdateDamagedPercentagesToVersion5 < ActiveRecord::Migration[6.0]
  def change
    update_view :damaged_percentages, version: 5, revert_to_version: 4
  end
end
