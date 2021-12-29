class CorrecionControl < ActiveRecord::Migration[6.0]
  def change
    remove_column :maintenance_controls, :responsable_id
    remove_column :maintenance_controls, :catalog_area_id
    add_column :maintenance_controls, :km_actual, :decimal
  end
end
