class PresupuestosCambiosHoy < ActiveRecord::Migration[6.0]
  def change
    remove_column :budget_concepts, :vehicle_type_id
    remove_column :budget_concepts, :catalog_model_id
    remove_column :budget_concepts, :unidad
    remove_column :budget_concepts, :descripcion
    add_reference :budget_concepts, :reason, foreign_key: true
  end
end
