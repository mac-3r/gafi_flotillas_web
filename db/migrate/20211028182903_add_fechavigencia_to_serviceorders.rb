class AddFechavigenciaToServiceorders < ActiveRecord::Migration[6.0]
  def change
    add_column :service_orders, :fecha_vigencia, :date
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
