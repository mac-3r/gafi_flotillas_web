class AddMotivosRechazo < ActiveRecord::Migration[6.0]
  def change
    add_column :purchase_orders, :motivo, :string
    add_column :budget_items, :motivo, :string
  end
end
