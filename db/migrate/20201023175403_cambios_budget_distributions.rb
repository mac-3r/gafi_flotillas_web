class CambiosBudgetDistributions < ActiveRecord::Migration[6.0]
  def change
    add_column :budget_distributions, :clave, :string
    remove_column :budget_distributions, :catalog_brand_id
    remove_column :budget_distributions, :importe
    remove_column :budget_distributions, :reason_id
    remove_column :budget_distributions, :plaqueo
    remove_column :budget_distributions, :seguro
    remove_column :budget_distributions, :muelles
    remove_column :budget_distributions, :caja
    remove_column :budget_distributions, :rotulacion
  end
end
