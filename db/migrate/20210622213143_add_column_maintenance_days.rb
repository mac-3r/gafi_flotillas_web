class AddColumnMaintenanceDays < ActiveRecord::Migration[6.0]
  def change
    add_column :maintenance_frecuencies, :dias, :integer
  end
end
