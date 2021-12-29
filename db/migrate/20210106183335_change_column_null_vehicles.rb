class ChangeColumnNullVehicles < ActiveRecord::Migration[6.0]
  def change
    change_column :vehicles, :catalog_personal_id, :integer, null:true
    change_column :vehicles, :responsable_id, :integer, null:true
    change_column :vehicles, :catalog_company_id, :integer, null:true
    change_column :vehicles, :catalog_route_id, :integer, null:true
    change_column :vehicles, :cost_center_id, :integer, null:true
    change_column :vehicles, :catalog_area_id, :integer, null:true
    change_column :vehicles, :plate_state_id, :integer, null:true
    change_column :vehicles, :policy_coverage_id, :integer, null:true
    change_column :vehicles, :insurance_beneficiary_id, :integer, null:true
    add_column :vehicle_consumptions, :impuestos, :decimal
  end
end
