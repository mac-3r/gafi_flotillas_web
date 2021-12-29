class AddColumnVendorWorkshops < ActiveRecord::Migration[6.0]
  def change
    add_reference :catalog_workshops, :catalog_vendor, foreign_key: true
  end
end
