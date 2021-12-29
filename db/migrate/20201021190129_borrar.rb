class Borrar < ActiveRecord::Migration[6.0]
  def change
    drop_table :budget_delivery_replacements
    drop_table :budget_sales_replacements
  end
end
