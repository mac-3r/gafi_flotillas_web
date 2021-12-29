class PresupuestosCambios < ActiveRecord::Migration[6.0]
  def change
    add_column :budget_concepts, :monto, :decimal
  end
end
