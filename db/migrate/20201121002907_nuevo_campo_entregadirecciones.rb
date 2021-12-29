class NuevoCampoEntregadirecciones < ActiveRecord::Migration[6.0]
  def change
    add_column :delivery_addresses, :clave, :string
  end
end
