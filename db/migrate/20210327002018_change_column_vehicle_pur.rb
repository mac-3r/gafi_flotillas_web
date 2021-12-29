class ChangeColumnVehiclePur < ActiveRecord::Migration[6.0]
  def change
    remove_column :vehicles, :purchase_detail_id
    add_reference :purchase_details, :vehicle, foreign_key: true, null:true
  end
end
