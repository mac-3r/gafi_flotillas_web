class AddColumnAdditionalServices < ActiveRecord::Migration[6.0]
  def change
    add_column :additional_services, :estatus, :integer
  end
end
