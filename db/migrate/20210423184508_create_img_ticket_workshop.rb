class CreateImgTicketWorkshop < ActiveRecord::Migration[6.0]
  def change
    create_table :img_ticket_workshops do |t|
      t.string  :imagen
      t.references :maintenance_ticket, null: false, foreign_key: true 
      t.timestamps
    end
    add_reference :service_orders, :maintenance_ticket 
    add_column :maintenance_tickets, :bandera_ticket_taller, :boolean, :default => false
    add_column :maintenance_tickets, :service_order_id, :integer
  end
end
