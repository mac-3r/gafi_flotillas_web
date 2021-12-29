class AddAutorizacionToBudgetitem < ActiveRecord::Migration[6.0]
  def change
    add_column :budget_items, :estatus_autorizacion, :integer, default: 1
  end
end
