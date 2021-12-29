class AddColumnCatalogRepairAbrev < ActiveRecord::Migration[6.0]
  def change
    add_column :catalog_repairs, :abreviatura, :string
  end
end
