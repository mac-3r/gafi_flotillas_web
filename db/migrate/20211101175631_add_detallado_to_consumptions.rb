class AddDetalladoToConsumptions < ActiveRecord::Migration[6.0]
  def change
    add_column :consumptions, :es_detallado, :boolean, default: true
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
