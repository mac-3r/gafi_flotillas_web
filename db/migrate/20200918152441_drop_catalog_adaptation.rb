class DropCatalogAdaptation < ActiveRecord::Migration[6.0]
  def change
      drop_table :catalog_adaptations
  end
end
