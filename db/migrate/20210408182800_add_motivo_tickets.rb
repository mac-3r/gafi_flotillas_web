class AddMotivoTickets < ActiveRecord::Migration[6.0]
  def change
    add_column :ticket_tire_batteries, :motivo, :string
  end
end
