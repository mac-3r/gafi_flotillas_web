class CampoRendimiento < ActiveRecord::Migration[6.0]
  def change
    add_column :monthly_yields, :rendimiento_ideal, :decimal
  end
end
