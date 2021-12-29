class CreateDeadlines < ActiveRecord::Migration[6.0]
  def change
    create_table :deadlines do |t|
      t.date :fecha_inicio
      t.date :fecha_fin

      t.timestamps
    end
    add_reference :insurance_report_tickets, :deadline, foreign_key: true
    remove_column :insurance_report_tickets, :estatus
    add_column :insurance_report_tickets, :estatus, :integer, default: 3
  end
end
