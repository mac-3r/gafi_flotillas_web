class AddRqfieldsToVehcons < ActiveRecord::Migration[6.0]
  def change
    add_reference :vehicle_consumptions, :catalog_branch
  end
end
