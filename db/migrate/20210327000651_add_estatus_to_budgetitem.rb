class AddEstatusToBudgetitem < ActiveRecord::Migration[6.0]
  def change
    add_column :budget_items, :estatus_compra, :boolean, default: false
  end
end
