class CorrectionsTables < ActiveRecord::Migration[6.0]
  def change
    add_column :competition_tables, :autorizante, :varchar
    add_column :competition_tables, :monto, :decimal
    remove_column :competition_tables, :gerencia_operaciones
    remove_column :competition_tables, :gerencia_corporativa
    remove_column :competition_tables, :direccion
  end
end
