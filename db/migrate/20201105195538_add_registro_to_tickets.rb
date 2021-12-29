class AddRegistroToTickets < ActiveRecord::Migration[6.0]
  def change
    add_column :insurance_report_tickets, :registro, :integer, default: 1
  end
end
