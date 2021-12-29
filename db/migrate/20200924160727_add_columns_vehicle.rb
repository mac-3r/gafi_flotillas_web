class AddColumnsVehicle < ActiveRecord::Migration[6.0]
  def change
    remove_column :vehicles, :branch_office_id, :integer
    add_reference :vehicles, :catalog_branch, foreign_key: true
    add_reference :vehicles, :catalog_area, foreign_key: true
    add_column :vehicles, :vehicle_color, :varchar
  end
end
