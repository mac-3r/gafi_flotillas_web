class CreateDamagedPercentages < ActiveRecord::Migration[6.0]
  def change
    create_view :damaged_percentages
  end
end
