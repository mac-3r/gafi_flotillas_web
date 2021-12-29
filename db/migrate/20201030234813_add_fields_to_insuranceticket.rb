class AddFieldsToInsuranceticket < ActiveRecord::Migration[6.0]
  def change
    add_column :insurance_report_tickets, :imagen_antes, :string
    add_column :insurance_report_tickets, :imagen_despues, :string
    add_column :insurance_report_tickets, :folio, :string
    remove_column :insurance_report_tickets, :estatus
    add_column :insurance_report_tickets, :estatus, :integer, default: 1
  end
end
