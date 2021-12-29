class AddColumnsCatalogBranches < ActiveRecord::Migration[6.0]
  def change
    add_column :catalog_branches, :unidad_negocio, :varchar
  end
end
