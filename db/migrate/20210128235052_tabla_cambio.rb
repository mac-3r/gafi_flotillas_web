class TablaCambio < ActiveRecord::Migration[6.0]
  def change
    add_column :competition_tables, :tipo, :string
  end
end
