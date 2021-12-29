class AddColumnProxVerificacion < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicles, :proxima_verificacion, :date
  end
end
