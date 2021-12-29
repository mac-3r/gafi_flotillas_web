class ChangeColumnNullVendors < ActiveRecord::Migration[6.0]
  def change
    change_column :catalog_workshops, :catalog_vendor_id, :integer, null:true
  end
end
