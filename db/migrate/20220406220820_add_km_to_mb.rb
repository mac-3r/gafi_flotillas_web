class AddKmToMb < ActiveRecord::Migration[6.0]
  def change
    add_column :maintenance_binnacles, :km, :float
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
