class UpdateDamagedPercentagesToVersion4 < ActiveRecord::Migration[6.0]
  def change
    update_view :damaged_percentages, version: 4, revert_to_version: 3
  end
end
