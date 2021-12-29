class AddReferencesToVehicles < ActiveRecord::Migration[6.0]
  def change
    add_reference :vehicles, :permission_type
    add_reference :vehicles, :vehicle_configuration
    add_reference :vehicles, :trailer_subtype
  end
end
