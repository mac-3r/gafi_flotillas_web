class AddColumnsCostCenters < ActiveRecord::Migration[6.0]
  def change
    add_reference :cost_centers, :catalog_company, foreign_key: true
    add_reference :cost_centers, :catalog_branch, foreign_key: true
    add_column :cost_centers, :unidad_negocio, :varchar
  end
end
