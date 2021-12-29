class AddFieldsToBudgets < ActiveRecord::Migration[6.0]
  def change
    add_column :budgets, :fecha_solicitud, :date
  end
end
