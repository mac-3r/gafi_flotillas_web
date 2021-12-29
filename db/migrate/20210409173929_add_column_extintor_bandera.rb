class AddColumnExtintorBandera < ActiveRecord::Migration[6.0]
  def change
    add_column :ticket_tire_batteries, :tipo_compra_extintor, :integer
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
