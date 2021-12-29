class ChangeColumnsVehicles < ActiveRecord::Migration[6.0]
  def change
    change_column :vehicles, :vehicle_status_id, :integer, null:true
    change_column :vehicles, :vehicle_type_id, :integer, null:true
    change_column :vehicles, :catalog_brand_id, :integer, null:true
    change_column :vehicles, :catalog_model_id, :integer, null:true
    change_column :vehicles, :billed_company_id, :integer, null:true
    add_column :vehicles, :impuestos, :decimal
    add_column :vehicles, :fecha_licencia, :date
    add_column :vehicles, :numero_licencia, :string
  end
end
