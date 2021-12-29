class AddTipoToOst < ActiveRecord::Migration[6.0]
  def change
    add_column :order_service_types, :tipo, :integer
  end
end
