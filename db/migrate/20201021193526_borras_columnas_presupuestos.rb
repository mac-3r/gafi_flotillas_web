class BorrasColumnasPresupuestos < ActiveRecord::Migration[6.0]
  def change
    remove_column :budget_concepts, :catalog_brand_id
    remove_column :budget_concepts, :plaqueo
    remove_column :budget_concepts, :seguro
    remove_column :budget_concepts, :reason_id
    remove_column :budget_concepts, :monto
    add_column :budget_concepts, :clave, :string
  end
end
