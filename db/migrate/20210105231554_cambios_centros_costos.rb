class CambiosCentrosCostos < ActiveRecord::Migration[6.0]
  def change
    add_reference :cost_centers, :catalog_area, foreign_key: true
    add_column :consumptions, :uuid, :string
    
  end
end
