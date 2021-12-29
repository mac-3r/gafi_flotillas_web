class UpdateDamagedPercentagesToVersion6 < ActiveRecord::Migration[6.0]
  def change
    update_view :damaged_percentages, version: 6, revert_to_version: 5
  end
end
