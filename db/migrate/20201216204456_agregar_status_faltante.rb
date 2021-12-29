class AgregarStatusFaltante < ActiveRecord::Migration[6.0]
  def change
    add_column :budget_concepts, :status, :int
    add_column :budget_administrations, :status, :int
    add_column :budget_distributions, :status, :int
    add_column :purchase_orders, :status, :int
  end
end
