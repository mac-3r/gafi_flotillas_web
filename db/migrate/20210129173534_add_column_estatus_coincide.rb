class AddColumnEstatusCoincide < ActiveRecord::Migration[6.0]
  def change
  add_column :purchase_orders, :coincidencia_estatus, :boolean, :default => 0
  end
end
