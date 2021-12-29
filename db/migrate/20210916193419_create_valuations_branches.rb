class CreateValuationsBranches < ActiveRecord::Migration[6.0]
  def change
    create_table :valuations_branches do |t|
      t.references :catalog_branch, null: false, foreign_key: true
      t.references :catalog_vendor, null: false, foreign_key: true
      t.references :valuation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
