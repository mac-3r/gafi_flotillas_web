class AddKmToTickets < ActiveRecord::Migration[6.0]
  def change
    add_column :maintenance_tickets, :km_actual, :integer
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
