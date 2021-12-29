class AddBanderaPolizas < ActiveRecord::Migration[6.0]
  def change
    add_column :consumptions, :base, :boolean
    add_column :vehicles, :base, :boolean
    add_column :vehicle_adaptations, :base, :boolean
    add_column :maintenance_controls, :base, :boolean
  end
end
