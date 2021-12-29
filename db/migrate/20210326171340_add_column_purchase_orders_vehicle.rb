class AddColumnPurchaseOrdersVehicle < ActiveRecord::Migration[6.0]
  def change
    add_reference :vehicles, :purchase_detail, foreign_key: true, null:true
  end
end
