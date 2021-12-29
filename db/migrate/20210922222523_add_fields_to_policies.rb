class AddFieldsToPolicies < ActiveRecord::Migration[6.0]
  def change
    add_reference :vehicle_adaptations, :catalog_area
    add_reference :vehicle_adaptations, :catalog_branch
    add_reference :purchase_orders, :catalog_area
  end
end
