class RmeoveColumn < ActiveRecord::Migration[6.0]
  def change
    remove_column :vehicles, :vehicle_permit_id
  end
end
