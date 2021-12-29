class IndexCostCenters < ActiveRecord::Migration[6.0]
  def change
    add_index :cost_centers, [:catalog_company_id, :catalog_branch_id, :catalog_area_id], :unique => true,name: 'index_fields'

  end
end
