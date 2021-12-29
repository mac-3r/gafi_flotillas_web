class RemoveIndexToCostcenter < ActiveRecord::Migration[6.0]
  def change
    remove_index :cost_centers, name: "index_fields"
    add_index :cost_centers, [:catalog_company_id, :catalog_branch_id, :catalog_area_id, :descripcion], unique: true, name: "index_fields"
  end
end
