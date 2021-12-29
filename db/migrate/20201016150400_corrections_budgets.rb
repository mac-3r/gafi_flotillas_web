class CorrectionsBudgets < ActiveRecord::Migration[6.0]
  def change
    remove_column :budget_concepts, :clave
    remove_column :budget_concepts, :status
    remove_column :budget_concepts, :cantidad
    remove_column :budget_concepts, :catalog_company_id
    add_column :budget_concepts, :fecha_entrega, :date
    add_column :budget_concepts, :plaqueo, :decimal
    add_column :budget_concepts, :seguro, :decimal
    add_reference :budget_concepts, :vehicle_type, foreign_key: true
    add_reference :budget_concepts, :catalog_model, foreign_key: true
    add_reference :budget_concepts, :catalog_brand, foreign_key: true
  end
end
