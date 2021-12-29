class AddStatusBranches < ActiveRecord::Migration[6.0]
  def change
    add_column :catalog_branches, :status, :boolean, default: true 
  end
end
