class AddBranchConsumption < ActiveRecord::Migration[6.0]
  def change
    add_reference :consumptions, :catalog_branch
  end
end
