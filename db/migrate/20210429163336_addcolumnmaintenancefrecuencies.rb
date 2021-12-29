class Addcolumnmaintenancefrecuencies < ActiveRecord::Migration[6.0]
  def change
    add_column :maintenance_frecuencies, :tipo, :integer
  end
end
