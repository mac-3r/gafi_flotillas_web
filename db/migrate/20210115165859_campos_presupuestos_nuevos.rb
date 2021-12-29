class CamposPresupuestosNuevos < ActiveRecord::Migration[6.0]
  def change
    add_reference :budget_details, :vehicle_type, foreign_key: true
    add_reference :budget_details, :catalog_model, foreign_key: true
    add_reference :budget_distribution_details, :vehicle_type, foreign_key: true
    add_reference :budget_distribution_details, :catalog_model, foreign_key: true
    add_reference :budget_administration_details, :vehicle_type, foreign_key: true
    add_reference :budget_administration_details, :catalog_model, foreign_key: true
  end
end
