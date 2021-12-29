class AddAreaToServord < ActiveRecord::Migration[6.0]
  def change
    add_reference :service_orders, :catalog_area
    add_reference :service_orders, :catalog_branch
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
