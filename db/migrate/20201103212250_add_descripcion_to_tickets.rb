class AddDescripcionToTickets < ActiveRecord::Migration[6.0]
  def change
    add_column :insurance_report_tickets, :contacto, :string
    add_column :insurance_report_tickets, :descripcion_mtc, :text
  end
end
