class AddColumnBranches < ActiveRecord::Migration[6.0]
  def change
    add_column :catalog_branches, :abreviacion, :string
  end
end
