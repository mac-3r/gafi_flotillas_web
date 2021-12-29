class CambiosPresupuestos < ActiveRecord::Migration[6.0]
  def change
    add_reference :budget_concepts, :catalog_area, foreign_key: true
    add_column :budget_concepts, :unidad, :integer
    add_column :budget_concepts, :cantidad, :integer
    add_reference :budget_concepts, :catalog_company, foreign_key: true
    add_column :budget_concepts, :fecha, :date
    add_reference :budget_concepts, :catalog_branch, foreign_key: true
  end
end
