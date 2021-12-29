class AddReferenceColumn < ActiveRecord::Migration[6.0]
  def change
    #remove_column :vehicles, :vehicle_model_id, :integer
    remove_column :vehicles, :vehicle_brand_id, :integer
    add_reference :vehicles, :catalog_model, foreign_key: true
    add_reference :vehicles, :catalog_brand, foreign_key: true
  end
end
