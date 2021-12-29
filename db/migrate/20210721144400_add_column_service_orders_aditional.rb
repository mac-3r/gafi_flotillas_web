class AddColumnServiceOrdersAditional < ActiveRecord::Migration[6.0]
  def change
     add_column :service_orders, :usuario_autoriza, :string
     add_column :service_orders, :precio, :decimal
  end
end
