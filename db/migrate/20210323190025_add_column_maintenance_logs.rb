class AddColumnMaintenanceLogs < ActiveRecord::Migration[6.0]
  def change
  remove_column :maintenance_logs, :catalog_brand_id
  add_reference :maintenance_logs, :vehicle, foreign_key: true
  end
end
