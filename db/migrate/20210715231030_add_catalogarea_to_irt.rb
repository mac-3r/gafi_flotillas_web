class AddCatalogareaToIrt < ActiveRecord::Migration[6.0]
  def change
    add_reference :insurance_report_tickets, :catalog_area
  end
end
