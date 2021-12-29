class AddFechasolicitudToBudgetitem < ActiveRecord::Migration[6.0]
  def change
    add_column :budget_items, :fecha_solicitud, :date
  end
end
