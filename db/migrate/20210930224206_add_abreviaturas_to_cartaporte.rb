class AddAbreviaturasToCartaporte < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_types, :abreviatura, :string
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
