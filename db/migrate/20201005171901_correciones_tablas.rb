class CorrecionesTablas < ActiveRecord::Migration[6.0]
  def change
    add_reference :vehicle_permits, :vehicle, foreign_key: true
    add_column :vehicle_permits, :fecha_vigencia, :date
    add_column :catalogo_adaptations, :monto, :decimal
    add_reference :fuel_budgets, :vehicle, foreign_key: true
    remove_column :fuel_budgets, :descripcion
    add_column :fuel_budgets, :litros, :decimal
    add_column :fuel_budgets, :formula_presupuesto, :varchar
    remove_column :type_sinisters, :descripcion
    remove_column :vehicle_indicators, :activacion
    remove_column :vehicle_indicators, :descripcion
  end
end
